USE Pharmacy;
/*---------------------------------------*/
/* INSERT, UPDATE, AND DELETE STATEMENTS */
/*---------------------------------------*/

/* Insert a new person into the database */
INSERT INTO person
VALUES ('Richard','K','Marini','123456789','98 Oak Forest, Katy, TX', '1962-12-30');

/* Insert a new product into the database */
INSERT INTO product
VALUES ("Apple", "6mg", "10", "4", "Eli-Lily");

/* Insert apple's active ingredients into the database */
INSERT INTO active_ingredients
VALUES ("cyanide", "Apple");

/* Inserts a new clinic into the table */
INSERT INTO clinic
VALUES('475 Wing St.','318-493-9923');

/* delete the person inserted earlier. He was not cool */
DELETE FROM person
WHERE ssn = '123456789';

/* Discount on apples. They're going bad soon */
UPDATE product
SET price = price * 0.9
WHERE Name = "Apple";

DELETE FROM product
WHERE name = 'apple';

/* Updates the address of person whos ssn is 123456789 */
/* He's cool again. He squats at the doctors office */
UPDATE Person
SET Address = '123 Main St.'
WHERE Ssn = '176920853';

/*----------*/
/* TRIGGERS */
/*----------*/

/* Trigger to automatically make stock of a new product 0 if unspecified */
DROP TRIGGER IF EXISTS new_product;
DELIMITER $$
CREATE TRIGGER new_product
BEFORE INSERT ON product
FOR EACH ROW
BEGIN
	IF (NEW.stock = '' or NEW.stock IS NULL)
    THEN
    SET NEW.stock = 0;	
    END IF;
END$$
DELIMITER;

/* Trigger to automatically price an order if price is left null by adding the prices of all individual items of the order */
DROP TRIGGER IF EXISTS Order_Price;
DELIMITER $$
CREATE TRIGGER Order_Price
BEFORE INSERT ON pharmacy.order
FOR EACH ROW
BEGIN
	IF (NEW.price IS NULL or NEW.price = 0)
    THEN 
    SET NEW.price = (SELECT SUM(Price)
				FROM buys b
				JOIN product p ON p.Name = b.ProdName
				WHERE b.Order_Num = 10);
	END IF;
END ;;
DELIMITER ;

DELETE FROM buys WHERE Order_Num = 10 AND ProdName = 'Plavix';
INSERT INTO buys 
VALUES ('836521394', 'Plavix', 10);

DELETE FROM pharmacy.order WHERE Order_Num = 10;
INSERT INTO pharmacy.order
VALUES (10, NULL,'2023-02-01');

/*-------*/
/* ALTER */
/*-------*/

ALTER TABLE Person
DROP COLUMN Phone_Number;
/* Adds phone number into the person table. Useful info */
ALTER TABLE Person
ADD COLUMN Phone_Number VARCHAR(11) AFTER Address;


