/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 *
  FROM [OLKramerdb].[dbo].[KHKVKBelegePositionen] where Artikelgruppe = '180' and Bezeichnung1 like '%CommVault Dienstleistungskontingent%' and Artikelnummer = 'I-S-3' 
  order by VorPosID

   
  select * from KHKVKBelegePositionen where vorposid in (106497, 106498, 119034)-- BelPosID = 540809

  select * from KHKVKVorgaengePositionen where vorposid in (106497, 106498, 119034) -- = 106497

  select * from KHKVKVorgaengePositionen where VorID = '26952'

  select *  from KHKVKBelegePositionen vkbp where vkbp.VorPosID in (select VorPosID from KHKVKVorgaengePositionen where VorID = '26952') and vkbp.Liefertermin between '2019-07-01 00:00:00.000' and '2019-09-30 00:00:00.000'
  select *  from KHKVKBelegePositionen vkbp where vkbp.VorPosID in (select VorPosID from KHKVKVorgaengePositionen) and vkbp.Liefertermin between '2019-07-01 00:00:00.000' and '2019-09-30 00:00:00.000'
  -- as [offener Roherlös/Euro]
  -- select * from KHKVKVorgaenge where VorID = 26952

  select * from KHKVKBelegePositionen vkbp where vkbp.BelID in (select vkb.Belegnummer from KHKVKBelege vkb where Belegart like '%angebot%')
				and (vkbp.Liefertermin between '2018-07-01 00:00:00.000' and '2019-09-30 00:00:00.000' or vkbp.Liefertermin is null)
  


    select sum(rabattbasis1) from KHKVKBelege where Belegart like '%rechnung%' and vorid=26952
	select * from KHKVKBelege where Belegart like '%rechnung%' and vorid=26952


select VorPosID from KHKVKBelegePositionen vkbp where vkbp.Liefertermin between '2019-07-01 00:00:00.000' and '2019-09-30 00:00:00.000'

select (GGBestellt-GGGeliefert) as "Fehlmenge" from KHKVKVorgaengePositionen vkvp 
where GGErfuellt = 0 and ((GGBestellt-GGGeliefert) > 0) and 
VorPosID in (select VorPosID from KHKVKBelegePositionen vkbp where vkbp.Liefertermin between '2019-07-01 00:00:00.000' and '2019-09-30 00:00:00.000')



select 
	(GGBestellt-GGGeliefert) as "Fehlmenge",
	vkbp.Einzelpreis,
	(GGBestellt-GGGeliefert)*vkbp.Einzelpreis as "Summe"
from KHKVKVorgaengePositionen vkvp inner join KHKVKBelegePositionen vkbp on vkbp.VorPosID = vkvp.VorPosID 
where 
	GGErfuellt = 0 and ((GGBestellt-GGGeliefert) > 0) and 
	(vkbp.Liefertermin between '2019-07-01 00:00:00.000' and '2019-09-30 00:00:00.000')
	and vkbp.Einzelpreis > 0
	

use OLKramerdb
Go

-- Tabelle erstellen und initial befüllen
select   (select top 1 vkb2.A0Name1 from khkvkbelege vkb2 where vkb2.BelID = vkbp.BelID ) as 'Kunde'
              -- ,vkvp.VorPosID  -- nur für Debug
              ,vkvp.Artikelnummer
              ,(select case when vkbp.Bezeichnung2 is null then vkbp.Bezeichnung1 else concat(vkbp.Bezeichnung1, ' - ', vkbp.Bezeichnung2) end from KHKVKBelegePositionen vkbp where vkbp.VorPosID = 50849 and vkbp.Liefertermin between '2019-07-01 00:00:00.000' and '2019-09-30 00:00:00.000') as 'Artikelbezeichnung'
              ,vkvp.GGBestellt
              ,vkvp.GGGeliefert
              ,(GGBestellt-GGGeliefert) as "Fehlmenge"
              ,vkbp.MengeBasiseinheit
              ,vkbp.Einzelpreis
              ,((GGBestellt-GGGeliefert) * vkbp.Einzelpreis) as "Fehlsumme"
       from KHKVKBelegePositionen vkbp join KHKVKVorgaengePositionen vkvp on vkbp.vorposid = vkvp.vorposid 
       where
              vkbp.Liefertermin between '2019-07-01 00:00:00.000' and '2019-09-30 00:00:00.000' and -- innerhalb eines bestimmten Zeitraumes
              vkvp.GGErfuellt = 0 and -- nicht erfüllter Auftrag
              (((vkvp.GGBestellt-vkvp.GGGeliefert) > 0) or (vkvp.GGBestellt-vkvp.GGBerechnet > 0)) and -- Fehlmenge größer 0 oder Berechnet größer 0
              ((GGBestellt-GGGeliefert) != 0) and -- weder Einzelpreis noch Fehlmenge = 0
              ((vkbp.Einzelpreis != 0) and ((GGBestellt-GGGeliefert) != 0)) -- weder Einzelpreis noch Fehlmenge = 0
              -- beispiel 
               and VorID = 13966
