%% pracownia oceniona na 18/20	90 %	 
%% Poprawność: 11, Efektywność: 3, Styl: 4. Dobre testy, ale trochę ich mało. 
%% Kod bardzo czytelny, ale moim zdaniem 140 znaków na wiersz to trochę za dużo (zalecałbym 80).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%                         Metody Programowania 2014 - Pracownia
%%						   Pawel Szymanski, nr. indeksu: 248082
%%						   Pracownia nr.1, wersja 2: "Kwadraty"
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rozwiazanie:
%% 		Rozwiazanie polega na generowaniu dla kazdej liczby z kolei kwadratu w kazdym z 
%% 		czterech kierunkow (sprawdzajac tez czy sa poprawne) i dodawaniu do listy Rozwiazanie
%%      w przypadku gdy wygenerujemy juz 4 kwadraty a dla 5 cyfry jest to nie mozliwe
%%      program wraca spowrotem do 4-tej cyfry i proboje wygenerowac dla niej inny kwadrat
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Nazewnictwo:
%%		Staralem sie trzymac CamelCase i ponazywac wszystko tak by bylo zrozumiale, 
%%      jednak chcialbym dodac ze jesli w predykacie pojawia sie
%% 		I lub J sa to zawsze zmienne zawierajace wspolrzedne
%%		odpowiednio: I - Wspolrzedna Pionowa, J- wspolrzedna Pozioma 
%%      Plansza( m x n):
%%      	m - IRozmiarTablicy
%%			n - JRozmiarTablicy
%% 		Kwadrat(i,j,d):
%%			i - I lub WspolrzednaIKwadratu lub KwadratI
%%			j - J lub WspolrzednaJKwadratu lub KwadratJ
%%          d - D lub RozmiarKwadratu lub Rozmiar
%%		Cyfra(i,j,l):
%%			i - WspolrzednaICyfry
%%			j - WspolrzednaJCyfry
%% 			l - Cyfra
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Czas:
%% 		Pracownia dla wszystkich testow z KNO ( latwe testy + trudny test) 
%%      I moich 6-sciu testow ( jednego latwego, jednego na poziomie trudnego z KNO
%%      oraz trudniejszego  20x20 z 30 cyframi) konczy dzialanie pozytywnie w 
%%      0.511s.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



:-[checker].

solve(IRozmiarTablicy,JRozmiarTablicy,ListaCyfr,Rozwiazanie):-
	generowanieRozwiazania(IRozmiarTablicy,JRozmiarTablicy, ListaCyfr ,Temp, [],ListaCyfr),
	reverse(Temp,Rozwiazanie).




%% ..........................::::::::::: Sekcja Generowania Rozwazania :::::::::::::::..................................

generowanieRozwiazania(IRozmiarTablicy,JRozmiarTablicy, [],  Akumulator, Akumulator,ListaCyfr):-!.
generowanieRozwiazania(IRozmiarTablicy,JRozmiarTablicy, [Cyfra|ListaResztyCyfr] ,Rozwiazanie, Akumulator,ListaCyfr):-
	generowanieKwadratowZeSprawdzaniemPoprawnosci(Cyfra, Kwadrat, IRozmiarTablicy, JRozmiarTablicy, Akumulator, ListaCyfr),
	Akumulator2 = [Kwadrat | Akumulator],
	generowanieRozwiazania(IRozmiarTablicy, JRozmiarTablicy, ListaResztyCyfr, Rozwiazanie, Akumulator2, ListaCyfr).
	




%% ..........................::::::::::::: Sekcja Generowania Kwadratow ::::::::::::::::..................................



% Predykat uruchamiajacy generator kwadratow i sprawdzaczke ich poprawnosci  
% zwraca pokolei generowane kwadraty pod warunkiem ze poprawnie przejda test 
% generowanieKwadratowZeSprawdzaniemPoprawnosci ( +WsporzedneCyfryDlaKtorejGenerujemyKwadraty, ?WspolrzedneWygenerowanegoKwadratu,
%												+I-tyRozmiarTablicy, +J-tyRozmiarTablicy, +ListaJuzUtworzonychKwadratow, +ListaCyfr)
generowanieKwadratowZeSprawdzaniemPoprawnosci(WspolrzedneCyfry,Kwadrat,IRozmiarTablicy,JRozmiarTablicy,ListaKwadratow,ListaCyfr):-
	generowanieKwadratowDlaCyfry(WspolrzedneCyfry, Kwadrat, IRozmiarTablicy,JRozmiarTablicy),
	sprawdzeniePoprawnosciKwadratu(Kwadrat, ListaKwadratow, ListaCyfr, WspolrzedneCyfry).


% Predykat generujacy kwadraty dla danej Cyfry poprzez uruchamianie pomniejszych generatorow
% zwraca pokolei generowane kwadraty
% generowanieKwadratowDlaCyfry (+WsporzedneCyfryDlaKtorejGenerujemyKwadraty, ?WspolrzedneWygenerowanegoKwadratu,
%												+I-tyRozmiarTablicy, +J-tyRozmiarTablicy)

generowanieKwadratowDlaCyfry(WspolrzedneCyfry,Kwadrat, IRozmiarTablicy,JRozmiarTablicy):-
	generowanieKwadratuLewoGora(WspolrzedneCyfry,Kwadrat, IRozmiarTablicy, JRozmiarTablicy); 
	generowanieKwadratuPrawoGora(WspolrzedneCyfry,Kwadrat, IRozmiarTablicy, JRozmiarTablicy);
	generowanieKwadratuLewoDol(WspolrzedneCyfry,Kwadrat, IRozmiarTablicy, JRozmiarTablicy);
	generowanieKwadratuPrawoDol(WspolrzedneCyfry,Kwadrat, IRozmiarTablicy, JRozmiarTablicy).



%% ..........................::::::::::::: Podsekcja Generatorow ::::::::::::::.................................

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% W tej sekcji umieszczone sa generatory (Prawo - Gora, Lewo-Gora, Prawo-Dol, Lewo Dol)
%% sa bardzo podobne wiec opisze je tutaj:
%%
%% Prawo - Dol zmienia tylko rozmiar kwadratu 
%% (Maks jest tu liczba oznaczajaca jak duzy zmiesci sie w tablicy)
%% Prawo - Gora zmniejsza tylko I-ta wspolrzedna i zwieksza rozmiar 
%% (Maks jest tu wartoscia jaka moze osiagnac I by nie wyjsc poza tablice)
%% Lewo - Gora zmniejsza obydwie wspolrzedne i zwieksza rozmiar kwadratu
%% (Maks jest tu najmniejszym I jaki moze siagnac I by nie wyjsc poza tablice)
%% Lewo - Dol zmniejsza J-ta wspolrzedna iz wieksza rozmiar
%% (Maks jest tu najmniejszym J jaki moze osiagnac by nie wyjsc poza tablice) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

generowanieKwadratuPrawoDol((WspolrzednaICyfry, WspolrzednaJCyfry, Cyfra), Kwadrat, IRozmiarTablicy, JRozmiarTablicy):-
	Maks is IRozmiarTablicy - WspolrzednaICyfry + 1,
	generatorKwadratuPrawoDol((WspolrzednaICyfry, WspolrzednaJCyfry),0,Kwadrat, Maks),
	zamianaNaListeRogow(Kwadrat, ListaRogow),
	sprawdzenieCzyKwadratMiesciSieNaTablicy(ListaRogow, IRozmiarTablicy, JRozmiarTablicy).


generatorKwadratuPrawoDol((WspolrzednaICyfry,WspolrzednaJCyfry), Maks,Kwadrat,Maks):-
	Kwadrat = (0,0,0),!.	
generatorKwadratuPrawoDol((WspolrzednaICyfry,WspolrzednaJCyfry),Rozmiar, Kwadrat,Maks):-
	RozmiarKwadratu is Rozmiar + 1,
	Kwadrat = (WspolrzednaICyfry,WspolrzednaJCyfry,RozmiarKwadratu).
generatorKwadratuPrawoDol((WspolrzednaICyfry,WspolrzednaJCyfry),Rozmiar, Kwadrat,Maks):-
	RozmiarKwadratu is Rozmiar + 1,
	generatorKwadratuPrawoDol((WspolrzednaICyfry,WspolrzednaJCyfry), RozmiarKwadratu, Kwadrat,Maks).






generowanieKwadratuLewoDol((WspolrzednaICyfry, WspolrzednaJCyfry, Cyfra), Kwadrat, IRozmiarTablicy, JRozmiarTablicy):-
	generatorKwadratuLewoDol((WspolrzednaICyfry, WspolrzednaJCyfry),0,Kwadrat, 0),
	zamianaNaListeRogow(Kwadrat, ListaRogow),
	sprawdzenieCzyKwadratMiesciSieNaTablicy(ListaRogow, IRozmiarTablicy, JRozmiarTablicy).


generatorKwadratuLewoDol((WspolrzednaIKwadratu,Maks),Rozmiar, Kwadrat,Maks):-
	Kwadrat = (0,0,0),!.	
generatorKwadratuLewoDol((WspolrzednaICyfry,WspolrzednaJCyfry),Rozmiar, Kwadrat,Maks):-
	WspolrzednaJKwadratu is WspolrzednaJCyfry - 1,
	RozmiarKwadratu is Rozmiar + 1,
	Kwadrat = (WspolrzednaICyfry,WspolrzednaJKwadratu,RozmiarKwadratu).
generatorKwadratuLewoDol((WspolrzednaICyfry,WspolrzednaJCyfry),Rozmiar, Kwadrat,Maks):-
	WspolrzednaJKwadratu is WspolrzednaJCyfry - 1,
	RozmiarKwadratu is Rozmiar + 1,
	generatorKwadratuLewoDol((WspolrzednaICyfry,WspolrzednaJKwadratu), RozmiarKwadratu, Kwadrat,Maks).






generowanieKwadratuPrawoGora((WspolrzednaICyfry, WspolrzednaJCyfry, Cyfra), Kwadrat, IRozmiarTablicy, JRozmiarTablicy):-
	generatorKwadratuPrawoGora((WspolrzednaICyfry, WspolrzednaJCyfry),0,Kwadrat, 0),
	zamianaNaListeRogow(Kwadrat, ListaRogow),
	sprawdzenieCzyKwadratMiesciSieNaTablicy(ListaRogow, IRozmiarTablicy, JRozmiarTablicy).


generatorKwadratuPrawoGora((Maks,WspolrzednaJCyfry),Rozmiar, Kwadrat,Maks):-
	Kwadrat = (0,0,0),!.	
generatorKwadratuPrawoGora((WspolrzednaICyfry,WspolrzednaJCyfry),Rozmiar, Kwadrat,Maks):-
	WspolrzednaIKwadratu is WspolrzednaICyfry - 1,
	RozmiarKwadratu is Rozmiar + 1,
	Kwadrat = (WspolrzednaIKwadratu,WspolrzednaJCyfry,RozmiarKwadratu).
generatorKwadratuPrawoGora((WspolrzednaICyfry,WspolrzednaJCyfry),Rozmiar, Kwadrat,Maks):-
	WspolrzednaIKwadratu is WspolrzednaICyfry - 1,
	RozmiarKwadratu is Rozmiar + 1,
	generatorKwadratuPrawoGora((WspolrzednaIKwadratu,WspolrzednaJCyfry), RozmiarKwadratu, Kwadrat,Maks).





generowanieKwadratuLewoGora((WspolrzednaICyfry, WspolrzednaJCyfry, Cyfra), Kwadrat, IRozmiarTablicy, JRozmiarTablicy):-
	generatorKwadratuLewoGora((WspolrzednaICyfry, WspolrzednaJCyfry),0,Kwadrat, 0),
	zamianaNaListeRogow(Kwadrat, ListaRogow),
	sprawdzenieCzyKwadratMiesciSieNaTablicy(ListaRogow, IRozmiarTablicy, JRozmiarTablicy).


generatorKwadratuLewoGora((WspolrzednaICyfry,Maks),Rozmiar, Kwadrat,Maks):-
	Kwadrat = (0,0,0),!.	
generatorKwadratuLewoGora((WspolrzednaICyfry,WspolrzednaJCyfry),Rozmiar, Kwadrat,Maks):-
	WspolrzednaIKwadratu is WspolrzednaICyfry - 1,
	WspolrzednaJKwadratu is WspolrzednaJCyfry - 1,
	RozmiarKwadratu is Rozmiar + 1,
	Kwadrat = (WspolrzednaIKwadratu,WspolrzednaJKwadratu,RozmiarKwadratu).
generatorKwadratuLewoGora((WspolrzednaICyfry,WspolrzednaJCyfry),Rozmiar, Kwadrat,Maks):-
	WspolrzednaIKwadratu is WspolrzednaICyfry - 1,
	WspolrzednaJKwadratu is WspolrzednaJCyfry - 1,
	RozmiarKwadratu is Rozmiar + 1,
	generatorKwadratuLewoGora((WspolrzednaIKwadratu,WspolrzednaJKwadratu), RozmiarKwadratu, Kwadrat,Maks).





%% ........................:::::: Sekcja sprawdzania poprawnosci kwadratow ::::::.................................



% predykat sprawdzjacy czy podany kwadrat miesci sie na zadanej IRozmiarTablicy
% predykat zwraca true jesli kwadrat miesci sie na tablicy i fail w przeciwnym wypadku
% sprawdzenieCzyKwadratMiesciSieNaTablicy( +ListaRogowKwadratu, +I-tyRozmiarTablicy, J-tyRozmiarTablicy)
sprawdzenieCzyKwadratMiesciSieNaTablicy([],IRozmiarTablicy,JRozmiarTablicy):-!.
sprawdzenieCzyKwadratMiesciSieNaTablicy([(I,J)|PozostalaListaRogow],IRozmiarTablicy,JRozmiarTablicy):-
	I >= 1,
	I =< IRozmiarTablicy,
	J >= 1,
	J =< JRozmiarTablicy,
	sprawdzenieCzyKwadratMiesciSieNaTablicy(PozostalaListaRogow,IRozmiarTablicy,JRozmiarTablicy).



% Ogolniejszy predykat sprawdzajacy poprawnosc kwadratu korzystajacy z innych predykatow mianowicie:
% sprawdzania czy ilosc cyfr w srodku kwadratu jest odpowiednia
% sprawdzania czy istnieja jakies cyfry na jego obwodzie
% sprawdzania kolizji z innmi kwadratami
% predykat zwraca true jesli kwadrat jest poprawny i fail w przeciwnym wypadku
% sprawdzeniePoprawnosciKwadratu( +WsporzedneKwadratu, +ListaJuzUtworzonychKwadratow,
%								 +ListaCyfr, +WspolrzedneCyfryDlaKtorejZostalWygenerowanyKwadrat)
sprawdzeniePoprawnosciKwadratu(WspolrzedneKwadratu, ListaKwadratow, ListaCyfr,
							 (WspolrzednaICyfry,WspolrzednaJCyfry, Cyfra)):-
	select((WspolrzednaICyfry,WspolrzednaJCyfry, Cyfra), ListaCyfr, ListaBezCyfryKwadratu),!,
	sprawdzenieIlosciCyfrWDanymKwadracie(WspolrzedneKwadratu, ListaBezCyfryKwadratu, IloscCyfr),
	IloscCyfr == Cyfra,
	\+ sprawdzanieIstnieniaCyfrNaObwodzie(WspolrzedneKwadratu, ListaBezCyfryKwadratu),
	sprawdzanieKolizjiZInnymiKwadratami(WspolrzedneKwadratu, ListaKwadratow).



% Predykat zliczajacy ilosc cyfr znajdujacych sie w srodku kwadratu
% sprawdzenieIlosciCyfrWDanymKwadracie( +WspolrzedneKwadratu, +ListaCyfr, ?IloscCyfr)

sprawdzenieIlosciCyfrWDanymKwadracie(WspolrzedneKwadratu, ListaCyfr, IloscCyfr):-
	zmianaNaListePolWewnetrznych(WspolrzedneKwadratu,ListaPolWewnetrznychKwadratu),
	wyliczanieIlosciCyfr(ListaPolWewnetrznychKwadratu, ListaCyfr, IloscCyfr).

wyliczanieIlosciCyfr(ListaPolWewnetrznychKwadratu, [], 0):-!.
wyliczanieIlosciCyfr(ListaPolWewnetrznychKwadratu, [(X,Y,Z)|ListaResztyCyfr], IloscCyfr):-
	member((X,Y), ListaPolWewnetrznychKwadratu),
	wyliczanieIlosciCyfr(ListaPolWewnetrznychKwadratu, ListaResztyCyfr, IloscCyfr2),
	IloscCyfr is IloscCyfr2 + 1,!.
wyliczanieIlosciCyfr(ListaPolWewnetrznychKwadratu, [(X,Y,Z)|ListaResztyCyfr], IloscCyfr):-	
	wyliczanieIlosciCyfr(ListaPolWewnetrznychKwadratu, ListaResztyCyfr, IloscCyfr).




% Predykat sprawdzajacy Kolizje z innymi kwadratami
% sprawdzanie polega na sprawdzeniu czy rogi kwadratow nie leza na obwodzie sprawdzanego kwadratu
% (kolizja odwrotna sprawdza czy rogi sprawdzanego kwadratu nie leza na obwodach kwadratow z listy)
% zwraca false jesli istnieje kolizja i true w przypadku jej braku
% sprawdzanieKolizjiZInnymiKwadratami( +SprawdzanyKwadrat, +ListaKwadratow)

sprawdzanieKolizjiZInnymiKwadratami(KwadratDoSprawdzenia, ListaKwadratow):-
	zmianaNaListePolObwodu(KwadratDoSprawdzenia, ListaPolObwoduKwadratu),
	sprawdzanieKolizjiKonkretnychKwadratow(ListaPolObwoduKwadratu, ListaKwadratow),
	zamianaNaListeRogow(KwadratDoSprawdzenia, ListaRogow),
	sprawdzanieKolizjiOdwrotnej(ListaRogow, ListaKwadratow).

sprawdzanieKolizjiOdwrotnej(ListaRogowKwadratu, []):-!.
sprawdzanieKolizjiOdwrotnej(ListaRogowKwadratu, [Kwadrat|ListaResztyKwadratow]):-
	zmianaNaListePolObwodu(Kwadrat, ListaPol),
	sprawdzanieKolizji(ListaPol, ListaRogowKwadratu),
	sprawdzanieKolizjiOdwrotnej(ListaRogowKwadratu, ListaResztyKwadratow).

sprawdzanieKolizjiKonkretnychKwadratow(PolaObwoduPierwszegoKwadratu, []):-!.
sprawdzanieKolizjiKonkretnychKwadratow(PolaObwoduPierwszegoKwadratu, [DrugiKwadrat|ListaResztyKwadratow]):-
	zamianaNaListeRogow(DrugiKwadrat, ListaRogow),
	sprawdzanieKolizji(PolaObwoduPierwszegoKwadratu, ListaRogow),
	sprawdzanieKolizjiKonkretnychKwadratow(PolaObwoduPierwszegoKwadratu,ListaResztyKwadratow).


sprawdzanieKolizji(PolaObwoduPierwszegoKwadratu, []):-!.
sprawdzanieKolizji(PolaObwoduPierwszegoKwadratu, [RogKwadratu|ResztaListyRogow]):-
	\+ member(RogKwadratu, PolaObwoduPierwszegoKwadratu),
	sprawdzanieKolizji(PolaObwoduPierwszegoKwadratu, ResztaListyRogow).



% Predykat sprawdzający czy na obwodzie zadanego kwadratu znajdują się jakieś cyfry 
% jeśli tak zwraca True, jesli nie false
% sprawdzanieIstnieniaCyfrNaObwodzie(+WspolrzedneKwadratu, +ListaCyfr)
sprawdzanieIstnieniaCyfrNaObwodzie((KwadratI,KwadratJ,KwadratD), ListaCyfr):-
	zmianaNaListePolObwodu((KwadratI,KwadratJ,KwadratD), ListaPol),
	\+ czyListaCyfrNaObwodzie(ListaPol, ListaCyfr).

czyListaCyfrNaObwodzie(ListaPol, []):-!.
czyListaCyfrNaObwodzie(ListaPol, [(WspolrzednaICyfry,WspolrzednaJCyfry,WartoscCyfry)|T]):-
	\+ member((WspolrzednaICyfry,WspolrzednaJCyfry),ListaPol),
	czyListaCyfrNaObwodzie(ListaPol, T).




%% ..............::::::: Sekcja zamiany kwadratow na pola ::::::::.........................




% Ponizsze predykaty słuza do zamiany podanego kwadratu na liste pol ktore zajmuje jego obwod
% oddzielnie generuje pionowe boki kwadratu i oddzielnie poziome ( tj, Z Maksem I pion, Z Maksem J poziom )
% zmianaNaListePol(+WspolrzedneKwadratu, ?ListaPol)

zmianaNaListePolObwodu((I,J,D),ListaPol):-
	MaksI is I + D,
	MaksJ is J + D,
	zmianaNaListePolObwoduZMaksemI((I,J),(MaksI,MaksJ),ListaPol2),
	zmianaNaListePolObwoduZMaksemJ((I,J),(MaksI,MaksJ),ListaPol3),
	append(ListaPol2, ListaPol3, ListaPol).

zmianaNaListePolObwoduZMaksemJ((MaksI, J), (MaksI, MaksJ), ListaPol):-
	ListaPol = [(MaksI, J),(MaksI,MaksJ)],!.
zmianaNaListePolObwoduZMaksemJ((I,J),(MaksI, MaksJ), ListaPol):-
	NastepneI is I + 1,
	zmianaNaListePolObwoduZMaksemJ((NastepneI, J), (MaksI, MaksJ), ListaPol2),
	ListaPol = [(I,J),(I,MaksJ)| ListaPol2].

zmianaNaListePolObwoduZMaksemI((I, MaksJ), (MaksI, MaksJ), ListaPol):-
	ListaPol = [(I,MaksJ)],!.	
zmianaNaListePolObwoduZMaksemI((I,J),(MaksI, MaksJ), ListaPol):-
	NastepneJ is J + 1,
	zmianaNaListePolObwoduZMaksemI((I, NastepneJ), (MaksI, MaksJ), ListaPol2),
	ListaPol = [(I,J),(MaksI, J)| ListaPol2].	



% Ponizsze predykaty sluza do zamiany podanego kwadratu na liste pol ktore zajmuje jego wenetrze 
% predykat dziala tak ze zmianaNaListePolObwoduZMaksem Tworzy kolumny a tworzenieWersu dorabia do nich wersy
% zmianaNaListePolWewnetrznych( +WspolrzedneKwadratu, ?ListaPol)


zmianaNaListePolWewnetrznych((I,J,D),ListaPol):-
	MaksI is I + (D - 1) ,
	MaksJ is J + D ,
	NastepneJ is J + 1,
	zamianaNaListePolWewnetrznychZMaksem((I,NastepneJ), (MaksI,MaksJ), ListaPol).

zamianaNaListePolWewnetrznychZMaksem((MaksI,J), (MaksI, MaksJ), ListaPol):-
	ListaPol =  [],!.

zamianaNaListePolWewnetrznychZMaksem((I,J), (MaksI, MaksJ), ListaPol):-
	NastepneI is I + 1,
	tworzenieWersu((NastepneI, J), MaksJ, ListaPol2),
	zamianaNaListePolWewnetrznychZMaksem((NastepneI, J), (MaksI, MaksJ), ListaPol3),
	append(ListaPol2, ListaPol3, ListaPol).
	

tworzenieWersu((I,MaksJ), MaksJ, ListaPol):-
	ListaPol = [],!.

tworzenieWersu((I,J), MaksJ, ListaPol):-
	J1 is J+1,
	tworzenieWersu((I,J1), MaksJ,ListaPol2),
	ListaPol = [(I,J)|ListaPol2].

% Predykat generuje 4-elementowa liste zawierajaca punkty na rogach kwadratu
% zamianaNaListeRogow(+WspolrzedneKwadratu, ?ListaRogow)
zamianaNaListeRogow((I,J,D), ListaPol):-
	MaksJ is J + D,
	MaksI is I + D,
	ListaPol = [(I,J),(MaksI,J),(I,MaksJ), (MaksI,MaksJ)].

%% ............::::::::: Koniec Programu :::::::::................




%% ............:::::::::: Sekcja Testow ::::::::::.................

%testy sprawdzajace poprawnosc sprawdzania kolizji pomiedzy kwadratami.
student_count_test(5,5, [(1,1,1),(2,2,0)], 6).
student_count_test(9,5, [(2,2,1),(3,3,1),(5,5,1),(6,4,0)],6).
student_count_test(3,10,[(1,1,0),(1,3,0),(2,5,0),(1,7,0),(2,8,0)],0).

% Wiekszy test sprawdzajacy jak radzi sobie przy duzych tablicach
% 20x20 i 30 cyfr 
student_simple_test(20,20,
	[(1,1,4),(1,9,1),(1,19,1),(2,2,4),(2,13,0),(2,18,0),(3,3,0),(3,6,1),(6,3,0),
	(7,11,0),(7,15,2),(8,17,0),(9,3,0),(9,17,0),(12,1,1),(12,14,2),(13,2,3),
	(13,17,0),(14,8,1),(15,3,0),(15,4,0),(15,6,1),(15,12,1),(15,17,0),(16,9,1),
	(18,11,0),(18,16,0),(19,1,0),(19,5,0),(19,18,0)],
	[(1,1,6),(1,9,5),(1,17,2),(2,2,8),(2,11,2),(2,16,2),(3,3,1),(3,6,6),
	 (5,3,1),(5,11,2),(7,15,3),(6,17,2),(8,3,1),(9,17,2),(12,1,2),(12,14,5),
	  (13,2,5),(13,17,1),(14,8,3),(15,1,2),(14,4,1),(12,6,3),(11,12,4), 
	  (15,17,1),(16,9,3),(18,11,2),(18,14,2),(19,1,1),(19,4,1),(18,17,1)]).

% sprawdzenie jak zachowuje sie dla waskich pionowych tablic (waskie poziome sa juz w testach z KNO)
student_simple_test(10,2,
	[(1,1,0),(3,2,0),(5,2,0),(7,1,0),(9,1,0)],
	 [(1,1,1),(3,1,1),(5,1,1),(7,1,1),(9,1,1)]).

% test pokroju trudnego testu z zagadki
student_simple_test(14,14,
	[(1,1,6),(1,12,0),(2,2,0),(2,4,1),(2,8,0),(3,5,1),(4,2,0),(4,12,0),
	(6,7,1),(7,14,1),(9,12,0),(10,3,2),(11,9,0),(11,12,1),(12,4,0),
	(12,5,0),(12,9,0),(12,11,0)],
	[ (1,1,8),(1,12,2),(2,2,1),(2,4,3),(2,8,3),(3,5,5),(4,2,1),(4,12,2),
	(6,2,5),(7,11,3),(8,12,1),(10,3,3),(10,8,1),(11,10,2),(12,2,2),
	(12,5,2),(12,8,1),(12,11,2)]).


	
