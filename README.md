# Rankless

Ova aplikacija izrađena je za natjecanje Lumen Development u 2021. godini. Na [linku](https://drive.google.com/drive/folders/13IDEvAgW9iAtkbGzAQKh97T1AJJXEu9Z?usp=sharing) se nalaze poslovni plan, dokumentacija demo aplikacije te izvršna datoteka.

## IMPORTANT
S obzirom da stvaranjem nove firme ta firma nema ispunjenih javnih anketa, preporučamo ulazak u profil sa email: ivan.horvat@email.com šifra:sifra123. 
Ta firma će imati podatke nekih javnih anketa te će biti vidljiv graf na Review ekranu, također taj profil ima status admina te može stvarati ankete i upravljati zaposlenicima na Manage ekranu.
Naravno potičemo i stvaranje vlastitog profila(možete koristiti nepostojeći mail u pravilnom formatu) i vlastite firme radi pregleda funkcionalnosti.

## Poznati bugovi
Istovremeno samo jedan admin bi trebao biti u Manage ekranu, inače ako dva admina mijenjaju pozicije i tagove istoj osobi neće u pravom vremenu vidjeti promjene koje načini onaj drugi(Ostat ce spremljena zadnja promjena, no izbacivanje zaposlenika bi moglo prouzročiti probleme).
Planirano rješenje: zabraniti ulazak u Manage ako je neki drugi admin trenutno na tom ekranu.
