SELECT * FROM marvel

---Confronto quanti film sono stati prodotti dalla Marvel e quanti da tutte le altre case produttrici

SELECT COUNT(title) FROM marvel
WHERE Distr='Walt Disney Studios Motion Pictures'

SELECT COUNT(title) FROM marvel
WHERE Distr!='Walt Disney Studios Motion Pictures'

---Circa la metà dei film Marvel sono stati prodotti dalla Walt Disney. 
---Adesso voglio verificare quanti di questi film sono stati prodotti dopo il 2012, anno di uscita del primo 'Avangers'

SELECT title, Real_year FROM marvel
ORDER BY Real_year ASC


SELECT COUNT(title) FROM marvel
WHERE Distr='Walt Disney Studios Motion Pictures' AND Real_year>2008

--- Confronto gli incassi dei film marvel, prima e dopo l'acquisizione da parte della Walt Disney Company (le analisi da qui in poi saranno realizzate tenendo conto dei guadagni Worldwide)

SELECT Distr, SUM(Worldwide) AS Tot_income FROM marvel
GROUP BY Distr
ORDER BY Tot_income DESC

---La Walt Disney ha realizzato più uncassi rispetto alle altre case produttrici, nonostante operi sul mercato da 9 anni (considerando il 2021 come anno attuale)

SELECT COUNT(Title) AS Most_prod, Distr FROM marvel
GROUP BY Distr
ORDER BY Most_prod

---Bisogna anche ricordare, come la Walt Disney sia la casa produttrice che ha realizzato più film marvel, solo la Sony e Fox possono essere considerate valide competitor
--- Confronto i guadagni realizzati in tutto il mondo dalle tre suddette case produttrici

SELECT Distr, SUM(Worldwide) AS Tot_income FROM marvel
WHERE Distr IN ('Walt Disney Studios Motion Pictures', 'Sony Pictures', '20th Century Fox') 
GROUP BY Distr
ORDER BY Tot_income DESC

---Analizzo i costi di produzione delle case produttrici per vedere se a budget elevati corrispondono proporzionalmente, guadagni elevati

SELECT Distr, SUM(Bud_mill) AS tot_budget FROM marvel
GROUP BY Distr
ORDER BY tot_budget DESC


SELECT Distr, SUM(Bud_mill)*1000000 AS tot_budget, SUM(Worldwide) AS Tot_income, (SUM(Bud_mill)*1000000/ SUM(Worldwide))*100 AS PercentageCostIncome FROM marvel
WHERE Distr<>'Total'
GROUP BY Distr
ORDER BY tot_budget DESC

---La percentuale che indica l'impatto dei costi sui guadagni totali sotto il 40% per 6 case produttrici su 10, in particolare: la peggior performance è della 20th Century Studios (137%), i cui costi di produzione superano i guadagni del 73%, ma è anche vero che ha prodotto un solo film
--- Tra le top 3 case produttrici, per film prodotti e incassi, la Walt Disney ha un tasso costi/guadagni migliore della Fox e molto simile, diverge di un solo punto percentuale, alla Sony
--- Si può concludere che il rapporto fra costi sostenuti e guadagni realizzati è molto simile, almeno per i produttori principali, quindi a maggiori investimenti corrispondono, proporzionalmente, maggiori guadagni

---Osservo quali  sono i film che hanno generato maggiori introiti e il rapporto costi/guadagni

SELECT Title, Distr,SUM(Bud_mill*1000000) AS tot_budget, SUM(Worldwide) AS Tot_income, (SUM(Bud_mill)*1000000/ SUM(Worldwide))*100 AS PercentageCostIncome FROM marvel 
GROUP BY Title, Distr
ORDER BY  PercentageCostIncome ASC

SELECT Title, Distr,SUM(Bud_mill*1000000) AS tot_budget, SUM(Worldwide) AS Tot_income, (SUM(Bud_mill)*1000000/ SUM(Worldwide))*100 AS PercentageCostIncome FROM marvel 
GROUP BY Title, Distr
ORDER BY Tot_income DESC

---Da quest'analisi si può notare come i film prodotti dalla Walt Disney, analizzati singolarmente, non hanno la miglior performance in termini di costi/guadagni, infatti il primo in lista è Endgame (5°)
--- Invece se il confronto fra film viene realizzato in termini di guadagni totali i film Walt Disney schizzano alle prime posizioni, quindi i loro film non sempre sono i migliori in temrini di margine di guadagno

---Analizzo le zone geografiche in cui le case di produzione hanno guadagnato maggiori introiti

SELECT Distr, SUM(Worldwide) AS Tot_World, SUM(North_America) AS Tot_NA, SUM(Other_territories) AS Tot_oth FROM marvel
GROUP BY Distr
ORDER BY Distr DESC

SELECT Distr, SUM(Open_week) AS Openweek FROM marvel
GROUP BY Distr
ORDER BY Openweek DESC

---La marvel si conferma al primo posto anche nei guadagni nella prima settimana

SELECT Real_year, SUM(Worldwide) AS Tot_World  FROM marvel
GROUP BY Real_year
ORDER BY Tot_World DESC

---Il 2018 è l'anno in cui si è incassato di più e Maggio il mese

SELECT Rel_Month, SUM(Worldwide) AS Tot_World  FROM marvel
GROUP BY Rel_Month
ORDER BY Tot_World DESC
