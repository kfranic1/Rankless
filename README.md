# Rankless

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### IMPORTANT
S obzirom da stvaranjem nove firme ta firma nema ispunjenih javnih anketa, preporučamo ulazak u profil sa email: ivan.horvat@email.com šifra:sifra123. 
Ta firma će imati podatke nekih javnih anketa te će biti vidljiv graf na Review ekranu, također taj profil ima status admina te može stvarati ankete i upravljati zaposlenicima na Manage ekranu.
Naravno potičemo i stvaranje vlastitog profila(možete koristiti nepostojeći mail u pravilnom formatu) i vlastite firme radi pregleda funkcionalnosti.

#### Poznati bugovi
Istovremeno samo jedan admin bi trebao biti u Manage ekranu, inače ako dva admina mijenjaju pozicije i tagove istoj osobi neće u pravom vremenu vidjeti promjene koje načini onaj drugi(Ostat ce spremljena zadnja promjena, no izbacivanje zaposlenika bi moglo prouzročiti probleme).
Planirano rješenje: zabraniti ulazak u Manage ako je neki drugi admin trenutno na tom ekranu.
