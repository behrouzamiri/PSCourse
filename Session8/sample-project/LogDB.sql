-- Log DB Creation
CREATE DATABASE PasswordResetDB;

USE PasswordResetDB;

CREATE TABLE PasswordResetLogs (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Username VARCHAR(255),
    Timestamp DATETIME DEFAULT GETDATE(),
    Status VARCHAR(50),
    FactorUsed VARCHAR(50),
    FactorValue VARCHAR(50),
    IPAddress VARCHAR(50),
    ErrorDetails VARCHAR(500)
);
