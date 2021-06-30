-- SQL Data Cleaning


-- Changing Date Format
-----------------------------------------------------------------------------------------------------------------------------

-- Add a new column called SaleDateCleanned to the table.
ALTER TABLE DataCleaningProject.dbo.NashvilleHousing
Add SaleDateCleaned Date;

-- Set the new column value by converting the SaleDate into Date formate.
Update DataCleaningProject.dbo.NashvilleHousing
SET SaleDateCleaned = CONVERT(Date,SaleDate)

-----------------------------------------------------------------------------------------------------------------------------


-- Filling up missing value- Property Address
-----------------------------------------------------------------------------------------------------------------------------

-- Check for missing value under PropertyAddress
SELECT *
FROM DataCleaningProject.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL

-- Check for Parcel ID. 
SELECT *
FROM DataCleaningProject.dbo.NashvilleHousing
ORDER BY ParcelID

-- Use SELF JOIN to join the same table to find out the corresponding PropertyAddress by the ParcelID. 
SELECT one.ParcelID, one.PropertyAddress, two.ParcelID, two.PropertyAddress, ISNULL(one.PropertyAddress, two.PropertyAddress)
FROM DataCleaningProject.dbo.NashvilleHousing one
JOIN DataCleaningProject.dbo.NashvilleHousing two
ON one.ParcelID = two.ParcelID
AND one.[UniqueID ] <> two.[UniqueID ]
WHERE one.PropertyAddress IS NULL

-- Update the table one by using table two
Update one
SET PropertyAddress = ISNULL(one.PropertyAddress, two.PropertyAddress)
FROM DataCleaningProject.dbo.NashvilleHousing one
JOIN DataCleaningProject.dbo.NashvilleHousing two
ON one.ParcelID = two.ParcelID
AND one.[UniqueID ] <> two.[UniqueID ]
WHERE one.PropertyAddress IS NULL
-----------------------------------------------------------------------------------------------------------------------------

-- Separating a string column into differnt columns - Property Address
-----------------------------------------------------------------------------------------------------------------------------

-- First checking the original prepertyAddress format
SELECT PropertyAddress
FROM DataCleaningProject.dbo.NashvilleHousing

-- Using SUBSTRING and SQL Server CHARINDEX() Function. The CHARINDEX would return the position of the string.
-- SUBSTRING function(column, starting position, ending position)
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS City
FROM DataCleaningProject.dbo.NashvilleHousing

-- Add and update the two columns
ALTER TABLE DataCleaningProject.dbo.NashvilleHousing
Add PropertyAddressCleanned Nvarchar(255)

Update DataCleaningProject.dbo.NashvilleHousing
SET PropertyAddressCleanned = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE DataCleaningProject.dbo.NashvilleHousing
Add PropertyCityCleanned Nvarchar(255)

Update DataCleaningProject.dbo.NashvilleHousing
SET PropertyCityCleanned = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


SELECT *
FROM DataCleaningProject.dbo.NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------------

-- Handling binary value - SoldAsVacant
-----------------------------------------------------------------------------------------------------------------------------

-- Check for distinct value under SoldAsVacant
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) AS distinctcount
FROM DataCleaningProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY distinctcount ASC

-- Using CASE statment to conduct the changing.
SELECT SoldAsVacant,

CASE
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM DataCleaningProject.dbo.NashvilleHousing

-- Update the table
Update DataCleaningProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
-----------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
-----------------------------------------------------------------------------------------------------------------------------

-- check for duplicates by assigning row_count
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
				UniqueID
				) row_count

FROM DataCleaningProject.dbo.NashvilleHousing

-- Create a CTE to find out if row_count is > 2, then DELETE it
WITH tempCTE AS(
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
				UniqueID
				) row_count

FROM DataCleaningProject.dbo.NashvilleHousing
)
--DELETE
--FROM tempCTE
SELECT * FROM tempCTE
WHERE row_count > 1

-----------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Column 
-----------------------------------------------------------------------------------------------------------------------------

--Check for unused column
SELECT *
FROM DataCleaningProject.dbo.NashvilleHousing

-- Delete columns
ALTER TABLE DataCleaningProject.dbo.NashvilleHousing
DROP COLUMN PropertyAddress, SaleDate









