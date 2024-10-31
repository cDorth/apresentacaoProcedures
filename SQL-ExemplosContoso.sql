USE ContosoRetailDW

--Exemplo 1
IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE TYPE = 'P' AND NAME = 'AddCustomer')
     BEGIN
         DROP PROCEDURE AddCustomer
     END
GO

CREATE PROCEDURE AddCustomer
      @CustomerKey NUMERIC,
      @GeographyKey NUMERIC,
      @CustomerLabel NVARCHAR (100),
      @FirstName NVARCHAR (50),
      @MiddleName NVARCHAR (50),
      @LastName NVARCHAR (50),
      @Gender VARCHAR (1)
AS
INSERT INTO DimCustomer (CustomerKey,GeographyKey,CustomerLabel,FirstName,MiddleName,LastName,Gender)
VALUES (@CustomerKey,@GeographyKey,@CustomerLabel,@FirstName,@MiddleName,@LastName,@Gender)

SET IDENTITY_INSERT DimCustomer ON;
EXEC AddCustomer 19146,736,CS4000,Fernando,Henrique,Cardoso,M
SELECT * FROM DimCustomer


--Exemplo 2
IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE TYPE = 'P' AND NAME = 'AumentoSalario')
     BEGIN
         DROP PROCEDURE AumentoSalario
     END
GO

CREATE PROCEDURE AumentoSalario
        @percentage DECIMAL (5, 2),
       @EmployeeKey INT
AS
BEGIN
  UPDATE DimEmployee
  SET BaseRate = BaseRate * (1 + @percentage / 100)
  WHERE EmployeeKey = @EmployeeKey
END;

EXEC AumentoSalario 20, 1


-- Exemplo 3
CREATE PROCEDURE ProcurarProdutos
       @ProductKey INT
AS
   BEGIN
      SELECT
           A.SalesKey,
           B.ChannelName,
           C.StoreName,
           D.ProductName,
           A.SalesAmount
   FROM FactSales AS A
       INNER JOIN DimChannel AS B ON A.ChannelKey = B.ChannelKey
          INNER JOIN DimStore AS C ON A.StoreKey = C.StoreKey
             INNER JOIN DimProduct AS D ON A.ProductKey = D.ProductKey
    WHERE D.ProductKey = @ProductKey
    ORDER BY A.SalesAmount DESC;
END;

EXEC ProcurarProdutos 2