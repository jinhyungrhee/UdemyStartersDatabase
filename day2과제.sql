CREATE TABLE menu(
p_code INT(5) PRIMARY KEY,
p_name CHAR(100) UNIQUE,
price INT(5) CHECK (price >= 100 AND price <= 10000),
stock INT(3) CHECK (stock >= 0),
contents TEXT,
image CHAR(50)
);


CREATE TABLE customer(
id CHAR(30) PRIMARY KEY,
c_name CHAR(30) NOT NULL,
email CHAR(30) UNIQUE,
phone CHAR(11) CHECK (phone LIKE ('010%')),
created_at DATETIME,
balance INT(7) CHECK (balance >= 0)
);

-- DROP TABLE orders;
-- DROP TABLE customer;
-- DROP TABLE menu;

CREATE TABLE orders(
o_code INT(5) PRIMARY KEY,
c_code CHAR(30),
p_code INT(5),
quantity INT(3) CHECK (quantity <= 100),
order_date DATETIME,
CONSTRAINT fk_orders_menu FOREIGN KEY(p_code) REFERENCES menu(p_code),
CONSTRAINT fk_orders_customer FOREIGN KEY(c_code) REFERENCES customer(id)
);

-- menu
INSERT INTO menu VALUES(1, '아메리카노', 2000, 100, '핫,아이스 선택가능:추가요금없음', 'americano.jpg');

INSERT INTO menu VALUES(2, '카페라떼', 3000, 100, '두유 변경가능:추가요금없음', 'latte.jpg');
INSERT INTO menu VALUES(3, '딸기바나나쥬스', 3000, 50, '딸기싱싱', 'ddalba.jpg');
INSERT INTO menu VALUES(4, '치즈케익', 5000, 10, '사이즈10*10', 'cheesecake.jpg');
INSERT INTO menu VALUES(5, '클럽샌드위치', 4500, 10, '치킨,베이컨선택가능:4조각', 'sandwich.jpg');

-- customer
INSERT INTO customer VALUES('jung1', '유정은', 'jung1@kitri.com', '0102223333', '2022-12-26', 30000);
INSERT INTO customer VALUES('inchul1', '신인철', 'in1@bit.com', '0103335677', '2022-11-26', 40000);
INSERT INTO customer VALUES('hee1', '황희정', 'heejung1@multi.com', '0102224444', '2021-12-26', 50000);

-- 주문
-- 1. 메뉴 이름과 가격, 상세설명을 조회하여 출력한다.
SELECT p_name, price, contents
FROM menu;

-- 2. 황희정 클럽샌드위치 2개 주문
-- 2-1. customer 테이블에서 황희정의 아이디와 잔액을 조회하여 출력한다.
SELECT id, balance
FROM customer
WHERE c_name='황희정';

--  2-2. menu 테이블에서 클럽샌드위치의 제품코드를 조회한다.
SELECT p_code 
FROM menu
WHERE p_name='클럽샌드위치';

-- 2-3. order 테이블에 주문번호는 1, 황희정아이디,클럽샌드위치의 제품코드, 
-- 주문시간은 현재시각, 구입수량은 2 의 레코드를 저장한다.
-- 하드코딩
-- INSERT INTO orders VALUES(1, 'hee1', 5, 2, NOW());

-- query 사용하기
INSERT INTO orders VALUES(2, 
(SELECT id FROM customer WHERE c_name='황희정'),
(SELECT p_code FROM menu WHERE p_name='클럽샌드위치'),
2,
NOW()
);

SELECT * FROM orders;
SELECT * FROM menu;
SELECT * FROM customer;

/*
SELECT SUM(quantity)
FROM orders
WHERE p_code=(SELECT p_code FROM menu WHERE p_name='클럽샌드위치');
*/

SELECT SUM(quantity) FROM orders WHERE p_code=(SELECT p_code FROM menu WHERE p_name='클럽샌드위치');

-- 2-4. menu 테이블의 클럽샌드위치 재고량 컬럼은 order 테이블의 구입수량만큼 뺀다.
UPDATE menu
SET stock = stock - (SELECT sum(quantity) FROM orders WHERE p_code=5)
WHERE p_name = '클럽샌드위치';

SELECT * FROM menu;


-- 2-5. customer 테이블의 잔액 컬럼은 menu 테이블의 가격 * order 테이블의 구입수량만큼 뺀다.
UPDATE customer
-- 체크 필요
SET balance = balance - ((SELECT price FROM menu WHERE p_name='클럽샌드위치') * (SELECT SUM(quantity) FROM orders WHERE p_code=(SELECT p_code FROM menu WHERE p_name='클럽샌드위치')))
-- SET balance = balance - ((SELECT price FROM menu WHERE p_name='클럽샌드위치') * (SELECT SUM(quantity) FROM orders WHERE p_code=2))
WHERE c_name = '황희정';

SELECT * FROM customer;

-- 2-6. 최종적으로 다음과 같이 조회하여 결과를 확인한다.
SELECT c_code AS '고객아이디', 
(SELECT c_name FROM customer WHERE id='hee1') AS '고객이름',
(SELECT p_name FROM menu WHERE p_code=(SELECT p_code FROM menu WHERE p_name='클럽샌드위치')) AS '제품이름',
(SELECT sum(quantity) FROM orders WHERE c_code='hee1') AS '구입수량',
((SELECT price FROM menu WHERE p_name='클럽샌드위치') * (SELECT SUM(quantity) FROM orders WHERE p_code=(SELECT p_code FROM menu WHERE p_name='클럽샌드위치'))) AS '결제액',
(SELECT balance FROM customer WHERE c_name='황희정') AS '잔액'
FROM orders
WHERE c_code='hee1';