# Project 2 - Data Cleaning

<br/>

**Project Summary:** Conducting Data Cleaning for a Housing Dataset.

**Tasks Involved:** bla bla bla

**Tools Used:** SQL

<br/>

## Data Summary and Preparation

- The dataset used in this project is the **Nashville_housing_data** which can be found on **Kaggle.**

- The dataset has **19 columns** and **56477** observations.

- The original dataset was dirty and now has been imported to Microsoft SQL server for Data Cleaning Process. 

- All SQL Query and Comment have been saved under **SQL code** in this directroy. 

## Changing Date Format

![](images/1.png)

First of all, the original SaleDate format is YYYY-MM-DD HH-MM-SS, which it is not very relevant, I am going to change it to YYYY-MM-DD.

I first by adding a new column called SaleDateCleanned to the table and set it by converting the SaleDate into Date formate by using the **CONVERT()** function, after that I deleted the old column.

## Filling up Missing Value- Property Address

Picture 2

By checking the missing value on PropertyAddress, there are a 29 NULL values but the rest of the column has included valuable information. The goal here is to find a way to fill them up. 

Picture 3

By ordering the ParcelID, We can see that the parcelID and Property Address are the same, which means we can fill up the correct property Address by referring to the correspondent ParcelID.

Picture 4

I have used **SELF JOIN** to check if table one ParcelID equals to table two ParcelID and table one UniqueID not equal to table two UniqueID. The outcome shows that the NULL PropertyAdress in table one can now be filled up with the correct address by referrring the corresponding ParcelID. By using the **ISNULL()** function, I can now replace and update the NULL value with the correct address.

## Separating a string column into differnt columns - Property Address

Picture 5

By looking at the Property Address column, we can see that there is only one delimiter separating the street and city. The goal here is to separate them into two columns.

Picture 6

I have Used the **SUBSTRING** function and SQL Server **CHARINDEX()** function to first by finding out the delimiter position value and substringed them by that value. I then added the two new columns named as PropertyAddressCleanned and PropertyCityCleanned by updating the table. 


## Handling Binary Value - SoldAsVacant

Picture 7

Under SoldAsVacant, the value should only be **Yes** or **No**. By using **DISTINCT**, **COUNT** and **GROUP BY** function, we can see that there are 4 different inputs as YES, NO, Y, N. The goal here is to combine them into either yes or no. 

Picture 8

I have used a **CASE** statment to control the change, **WHEN** SoldAsVacant is'Y'/'N' **THEN** 'Yes'/'No', **ELSE** would reamins SoldAsVacant. After that, I updated the table. 


## Remove Duplicates

Picture 9

To define a duplicate entry in this dataset, it would means that the row would have the same column value but with a different UniqueID. Therefore, I am going to take the key columns(ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference) as an indicator. 

To do this, I first used the **ROW_NUMBER** funtion to give each row a count number and followed with the **PARTITION BY** function to partition out the columns that should be unique. From the diagram above, I have found a duplicate which the row count of 2. 

Picture 10

After that, I created a **CTE** table named as tempCTE which included the query from the above task, and run a **SELECT** statment **FROM** the tempCTE **WHERE row_count > 2** in order to filter out all the duplicate rows. Once we filtered them out, I used **DELETE** function to remove all those duplicates. 

## Deleting Unused Columns

Picture 11

By recalling the tasks I have done above, I have created few new columns named with the name Cleanned, so now I have to delete those old columns which I don't need them anymore. 

A small note is do not do this to the raw data without any confirmation from the stakeholder.  

Picture 12

I have used **ALTER TABLE** and **DROP COLUMN** function to remove those old columns. 










