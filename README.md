# Concordia Cart App
#### How to Run:

  NOTE: Preffered IDE is Eclipse Enterprise Edition

  This project must be ran on a Tomcat Server Version 8 or after.

  You must have maven set up.

  1. Once you import the code onto ur Eclipse workspace. 

  2. Right-Click on the file and go to Maven -> Maven Build -> In the Goals section type -> clean install.

  3. Then click apply.

  4. Then Right-Click again on your project.

  5. Choose Run-as -> Run on Server and choose the Tomcat server you like to use.

  6. If you don't have Tomcat server installed don't worry when adding the server onto ur IDE.

  7. Eclipse has the option to download it from their IDE.

NOTE: BEFORE RUNNING THE PROJECT GO TO APPLICATION.PROPERTIES FILE IN SRC AND CHANGE THE SQL USERNAME AND PASSWORD TO CONFORM WITH 
YOUR SQL WORKBENCH USERNAME AND PASSWORD. THEN RUN THESE FOLLOWING COMMANDS IN A SEPERATE QUERY TAB.

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
