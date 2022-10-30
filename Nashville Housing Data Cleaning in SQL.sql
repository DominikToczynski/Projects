

-- Data Cleaning Project

USE Nashville_Housing;

SELECT * 
FROM housing;

-- standarize Date Format

-- this one doesn't update values

UPDATE housing
SET SaleDate = CONVERT(Date,SaleDate);

SELECT SaleDate, CONVERT(Date,SaleDate)
FROM housing;

-- we are creating another column for sale dates, so that we can populate it with correct date format

ALTER TABLE housing
ADD SaleDateConvert DATE;

-- populating newly created column

UPDATE housing
SET SaleDateConvert = CONVERT(Date,SaleDate);

SELECT SaleDateConvert
FROM housing;

-- removing unecessary column

ALTER TABLE housing
DROP COLUMN SaleDate;

-- all works fine now

-- populate property address data

SELECT *
FROM housing
-- WHERE PropertyAddress is NULL
ORDER BY ParcelID;

-- we can populate PropertyAddress using ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM housing a
JOIN housing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM housing a
JOIN housing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

-- breaking out PropertyAddress into individual columns (Address1, Address2 (City))

SELECT PropertyAddress
FROM housing;

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS Address
FROM housing

-- creating new columns for separate address values

ALTER TABLE housing
ADD Address1 VARCHAR(255);

ALTER TABLE housing
ADD Address2 VARCHAR(255);

-- updating newly created address columns

UPDATE housing
SET Address1 = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

UPDATE housing
SET Address2 = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

SELECT Address1, Address2
FROM housing;

-- removing unecessary PropertyAddress column

ALTER TABLE housing
DROP COLUMN PropertyAddress;

-- breaking out OwnerAddress into individual columns (OwnerAddress1, OwnerAddressCity, OwnerAddressState)

SELECT OwnerAddress
FROM housing;

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM housing

ALTER TABLE housing
ADD OwnerAddress1 VARCHAR(255);

ALTER TABLE housing
ADD OwnerAddressCity VARCHAR(255);

ALTER TABLE housing
ADD OwnerAddressState VARCHAR(255);

UPDATE housing
SET OwnerAddress1 = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

UPDATE housing
SET OwnerAddressCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

UPDATE housing
SET OwnerAddressState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

ALTER TABLE housing
DROP COLUMN OwnerAddress;

SELECT OwnerAddress1, OwnerAddressCity, OwnerAddressState
FROM housing;

-- change Y and N to 'Yes' and 'No' in "Sold as Vacant" coulmn

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM housing
GROUP BY SoldAsVacant
ORDER BY 2;


SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
	END
FROM housing;

UPDATE housing
SET SoldAsVacant = 
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
	END;

--  remove duplicates

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 Address1,
				 Address2,
				 SalePrice,
				 SaleDateConvert,
				 LegalReference
	ORDER BY UniqueID) row_num
FROM housing
)
SELECT * -- DELETE was used in here instead of SELECT to remove duplicated rows
FROM RowNumCTE
WHERE row_num > 1;


SELECT *
FROM housing;

