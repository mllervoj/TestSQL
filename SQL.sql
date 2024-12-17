SELECT 	os.jmeno || ' ' || os.prijmeni || ' (' || os.funkce || ') ' AS osoba, 
		sp.nazev || ' (' || sp.ICO || ')' AS spolecnost,
		si.typ AS typSidla,
		si.adresa_ulice || ' ' || si.adresa_c_d || '/' || si.adresa_c_o || ', ' || si.adresa_obec || ' ' || si.adresa_psc || ', ' || si.adresa_stat AS adresa
FROM data.Osoby os
LEFT JOIN data.Osoby_Spolecnosti_Sidla oss ON os.osobaId = oss.osobaID
LEFT JOIN data.Spolecnosti sp ON oss.spolecnostID = sp.spolecnostID
LEFT JOIN data.Sidla si ON oss.sidloID = si.sidloID;



