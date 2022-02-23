create  proc [dbo].[vul_Clients] as 

/*

2022-01-07 Howard   Creatie


*/


truncate table dbo.[Clients]

SET IDENTITY_INSERT Clients on 


insert into Clients(
        [Id]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[ClientNumber]
      ,[NationalIdentifier]
      ,[BirthName]
      ,[Initials]
      ,[FirstName]
      ,[PartnerName]
      ,[PrefixPartnerName]
      ,[Street]
      ,[HouseNumber]
      ,[HouseNumberAddition]
      ,[PostalCode]
      ,[City]
      ,[Gender]
      ,[DateOfBirth]
      ,[PhoneNumber]
      ,[Deceased]
      ,[Removed]
      ,[OrganizationId]
      ,[CorrespondenceStreet]
      ,[CorrespondenceCity]
      ,[CorrespondenceCountryId]
      ,[CorrespondencePostalCode]
      ,[CorresponenceAttentionOf]
      ,[CountryId]
      ,[Email]
      ,[PhoneNumberMobile]
      ,[Referrer]
      ,[ValidationError]
      ,[PhoneNumberWork]
      ,[PrefixBirthName]
      ,[Picture]
      ,[Title]
      ,[DateOfDeath]
      ,[UseDifferentCorrespondenceAddress]
      ,[CorrespondenceHouseNumber]
      ,[CorrespondenceHouseNumberAddition]
      ,[FullName]
      ,[ExternalId]
 
     
  

)
SELECT 
     [Id]
      ,[CreatedBy]
      ,[Created]
      ,[LastModifiedBy]
      ,[LastModified]
      ,[ClientNumber]
      ,[NationalIdentifier]
      ,[BirthName]
      ,[Initials]
      ,[FirstName]
      ,[PartnerName]
      ,[PrefixPartnerName]
      ,[Street]
      ,[HouseNumber]
      ,[HouseNumberAddition]
      ,[PostalCode]
      ,[City]
      ,[Gender]
      ,[DateOfBirth]
      ,[PhoneNumber]
      ,[Deceased]
      ,[Removed]
      ,[OrganizationId]
      ,[CorrespondenceStreet]
      ,[CorrespondenceCity]
      ,[CorrespondenceCountryId]
      ,[CorrespondencePostalCode]
      ,[CorresponenceAttentionOf]
      ,[CountryId]
      ,[Email]
      ,[PhoneNumberMobile]
      ,[Referrer]
      ,[ValidationError]
      ,[PhoneNumberWork]
      ,[PrefixBirthName]
      ,[Picture]
      ,[Title]
      ,[DateOfDeath]
      ,[UseDifferentCorrespondenceAddress]
      ,[CorrespondenceHouseNumber]
      ,[CorrespondenceHouseNumberAddition]
      ,[FullName]
      ,[ExternalId]
 
  
  FROM [ZPMGGZ].[ZORGGGZ_PRD].[dbo].[Clients]

  SET IDENTITY_INSERT Clients off