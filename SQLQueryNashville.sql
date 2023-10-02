SELECT*FROM Nashville

---Converto la formattazzione della colonna Saledate in un formato facilmente leggibile

SELECT SaleDate, CONVERT(Date,SaleDate) AS Saledate
FROM Nashville

UPDATE Nashville
SET SaleDate=CONVERT(Date,SaleDate)

ALTER TABLE Nashville
ADD SaleDateNew DATE

UPDATE Nashville
SET SaleDateNew=CONVERT(Date,SaleDate)

ALTER TABLE Nashville
DROP SaleDate

---Aggiungo i dati mancanti nella colonna Address, considerando che ad ogni Parcel id corrisponde un indirizzo specifico
---Ad ogni ParcelID corrisponde un differente PropertyAddress, ci sono duplicati di alcuni ParcelId a cui non corrisponde nessun PropertyAddress. L'obiettivo è trovare i ParcelId uguali, identificare quelli senza Property Address e riempire le caselle mancanti con il PropertyAddress del duplicato del ParcelId, a cui corrisponde un PropertyAddress.

SELECT * FROM Nashville
WHERE PropertyAddress IS NULL

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) FROM Nashville a
JOIN Nashville b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Nashville a
JOIN Nashville b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]

---Suddividere la colonna PropertyAddress in differenti colonne per stato, città e indirizzo
--- INDEX restituisce uno specifico valore
SELECT SUBSTRING( PropertyAddress, 1, CHARINDEX(',',PropertyAddress)) AS Address
FROM Nashville ---Restituisce indirizzi dal primo valore alla virgola

SELECT CHARINDEX (',',PropertyAddress) FROM Nashville--- Restituisce quanti caratteri ci sono tra il primo valore e quello ricercato

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From Nashville

ALTER TABLE Nashville
ADD PropertySplitAddress Nvarchar(255)

UPDATE Nashville
SET PropertySplitAddress=SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Nashville
ADD PropertySplitCity Nvarchar(255)

UPDATE Nashville
SET PropertySplitCity=SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

---Ho creato due tabelle che contengono, la prima, gli elementi compresi tra valore che si trova nella posizione numero 1 della colonna PropertyAddress, fino alla virgola, mentre la seconda colonna, contiente gli elementi dalla virgola all'ultimo carattere corrispondente alla lunghezza della parola

SELECT*FROM Nashville


---Adesso separo, in differenti colonne, gli elementi della colonna owneraddress attraverso il comando parsename
---PARSENAME utile a dividere in differenti colonne gli elementi divisi da punti

SELECT OwnerAddress FROM Nashville

---Devo cambiare primale virgole in punti per applicare parsename
SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM Nashville

ALTER TABLE Nashville
ADD OwnerSplitAddress Nvarchar(255)

UPDATE Nashville
SET OwnerSplitAddress= PARSENAME(REPLACE(OwnerAddress,',','.'),3)


ALTER TABLE Nashville
ADD OwnerSplitCity Nvarchar(255)

UPDATE Nashville
SET OwnerSplitCity= PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE Nashville
ADD OwnerSplitState Nvarchar(255)

UPDATE Nashville
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT*FROM Nashville

---Sostituisco Yes a Y e No a N nella colonna SoldAsVacant

SELECT SoldAsVacant,

CASE WHEN SoldAsVacant= 'Y' THEN 'Yes'
WHEN SoldAsVacant= 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM Nashville

ALTER TABLE Nashville
ADD SoldVacant VARCHAR(2)

UPDATE Nashville
SET SoldAsVacant = CASE WHEN SoldAsVacant= 'Y' THEN 'Yes'
WHEN SoldAsVacant= 'N' THEN 'No'
ELSE SoldAsVacant
END


SELECT distinct(SoldAsVacant) from Nashville

---Elimino i duplicati
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDateNew,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Nashville)


Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.NashvilleHousing


---Elimino le colonne che non uso (Owner name,OwnerAddress,TaxDistrict, PropertyAddress, Soldvacant)

ALTER TABLE Nashville
DROP COLUMN SaleDate, OwnerAddress,TaxDistrict, PropertyAddress 

ALTER TABLE Nashville
DROP COLUMN Soldvacant

SELECT*FROM Nashville