# Comp354Project



======================

Run the following SQL queries IN ORDER:

ALTER TABLE product
ADD COLUMN usedpquantity INT
DEFAULT 0;

ALTER TABLE product
ADD COLUMN usedpprice DECIMAL(12,2)
DEFAULT 0.0;

ALTER TABLE product
ADD COLUMN discountpprice DECIMAL(12,2)
DEFAULT 0.0;

ALTER TABLE orders
ADD COLUMN used BOOLEAN
DEFAULT false;

ALTER TABLE usercart
ADD COLUMN used BOOLEAN
DEFAULT false;

======================

To update the prices to CAD run the following:


SET SQL_SAFE_UPDATES = 0;

UPDATE product
SET pprice = pprice*0.016;

UPDATE orders
SET amount = amount*0.016;

UPDATE transactions
SET amount = amount*0.016;

SET SQL_SAFE_UPDATES = 1;

======================
