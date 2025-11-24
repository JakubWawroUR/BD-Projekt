--
-- PostgreSQL database dump
--

\restrict J8LKvHSFiz2RolwGzF0dFGgOBNBmQvI0Fo1yVgqCdeMLrHSY4BDGNDBNGPcPtKN

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2025-11-24 08:39:55

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 874 (class 1247 OID 16400)
-- Name: jednostka_miary; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.jednostka_miary AS ENUM (
    'g',
    'ml',
    'szt',
    'łyżeczka',
    'łyżka',
    'szczypta'
);


ALTER TYPE public.jednostka_miary OWNER TO postgres;

--
-- TOC entry 871 (class 1247 OID 16390)
-- Name: status_przepisu; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status_przepisu AS ENUM (
    'DRAFT',
    'PUBLICZNY',
    'PRYWATNY',
    'ARCHIWUM'
);


ALTER TYPE public.status_przepisu OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 230 (class 1259 OID 16486)
-- Name: kroki_przygotowania; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kroki_przygotowania (
    id_kroku integer NOT NULL,
    opis_kroku text NOT NULL
);


ALTER TABLE public.kroki_przygotowania OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16485)
-- Name: kroki_przygotowania_id_kroku_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kroki_przygotowania_id_kroku_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kroki_przygotowania_id_kroku_seq OWNER TO postgres;

--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 229
-- Name: kroki_przygotowania_id_kroku_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kroki_przygotowania_id_kroku_seq OWNED BY public.kroki_przygotowania.id_kroku;


--
-- TOC entry 238 (class 1259 OID 16606)
-- Name: kroki_skladniki; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kroki_skladniki (
    id_przepisu integer NOT NULL,
    numer_kroku integer NOT NULL,
    id_skladnika integer NOT NULL
);


ALTER TABLE public.kroki_skladniki OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16414)
-- Name: lokalizacje; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lokalizacje (
    id_lokalizacji integer NOT NULL,
    kraj character varying(100) NOT NULL,
    wojewodztwo character varying(100),
    miasto character varying(100) NOT NULL
);


ALTER TABLE public.lokalizacje OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16413)
-- Name: lokalizacje_id_lokalizacji_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lokalizacje_id_lokalizacji_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lokalizacje_id_lokalizacji_seq OWNER TO postgres;

--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 219
-- Name: lokalizacje_id_lokalizacji_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lokalizacje_id_lokalizacji_seq OWNED BY public.lokalizacje.id_lokalizacji;


--
-- TOC entry 233 (class 1259 OID 16532)
-- Name: oceny; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oceny (
    id_przepisu integer NOT NULL,
    id_uzytkownika integer NOT NULL,
    ocena integer NOT NULL,
    data_dodania timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT oceny_ocena_check CHECK (((ocena >= 1) AND (ocena <= 5)))
);


ALTER TABLE public.oceny OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16467)
-- Name: przepisy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.przepisy (
    id_przepisu integer NOT NULL,
    id_uzytkownika integer NOT NULL,
    nazwa character varying(255) NOT NULL,
    czas_przygotowania integer,
    liczba_porcji integer,
    data_utworzenia date DEFAULT CURRENT_DATE NOT NULL,
    status public.status_przepisu DEFAULT 'DRAFT'::public.status_przepisu NOT NULL
);


ALTER TABLE public.przepisy OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16466)
-- Name: przepisy_id_przepisu_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.przepisy_id_przepisu_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.przepisy_id_przepisu_seq OWNER TO postgres;

--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 227
-- Name: przepisy_id_przepisu_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.przepisy_id_przepisu_seq OWNED BY public.przepisy.id_przepisu;


--
-- TOC entry 237 (class 1259 OID 16588)
-- Name: przepisy_kroki; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.przepisy_kroki (
    id_przepisu integer NOT NULL,
    numer_kroku integer NOT NULL,
    id_kroku integer NOT NULL,
    czas_trwania_minuty integer
);


ALTER TABLE public.przepisy_kroki OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16513)
-- Name: przepisy_skladniki; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.przepisy_skladniki (
    id_przepisu integer NOT NULL,
    id_skladnika integer NOT NULL,
    ilosc numeric(8,2) NOT NULL,
    jednostka public.jednostka_miary NOT NULL
);


ALTER TABLE public.przepisy_skladniki OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16496)
-- Name: przepisy_tagi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.przepisy_tagi (
    id_przepisu integer NOT NULL,
    id_tagu integer NOT NULL
);


ALTER TABLE public.przepisy_tagi OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16445)
-- Name: skladniki; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.skladniki (
    id_skladnika integer NOT NULL,
    nazwa character varying(100) NOT NULL,
    kalorycznosc_na_100g numeric(6,2),
    koszt_jednostkowy_pln numeric(6,2)
);


ALTER TABLE public.skladniki OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16444)
-- Name: skladniki_id_skladnika_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.skladniki_id_skladnika_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.skladniki_id_skladnika_seq OWNER TO postgres;

--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 223
-- Name: skladniki_id_skladnika_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.skladniki_id_skladnika_seq OWNED BY public.skladniki.id_skladnika;


--
-- TOC entry 226 (class 1259 OID 16456)
-- Name: tagi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tagi (
    id_tagu integer NOT NULL,
    nazwa character varying(50) NOT NULL
);


ALTER TABLE public.tagi OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16455)
-- Name: tagi_id_tagu_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tagi_id_tagu_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tagi_id_tagu_seq OWNER TO postgres;

--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 225
-- Name: tagi_id_tagu_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tagi_id_tagu_seq OWNED BY public.tagi.id_tagu;


--
-- TOC entry 234 (class 1259 OID 16553)
-- Name: ulubione; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ulubione (
    id_przepisu integer NOT NULL,
    id_uzytkownika integer NOT NULL,
    data_dodania timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.ulubione OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16424)
-- Name: uzytkownicy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.uzytkownicy (
    id_uzytkownika integer NOT NULL,
    imie character varying(50),
    nazwisko character varying(50),
    nazwa_uzytkownika character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    data_rejestracji date DEFAULT CURRENT_DATE NOT NULL,
    rok_urodzenia integer,
    id_lokalizacji integer
);


ALTER TABLE public.uzytkownicy OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16423)
-- Name: uzytkownicy_id_uzytkownika_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.uzytkownicy_id_uzytkownika_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.uzytkownicy_id_uzytkownika_seq OWNER TO postgres;

--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 221
-- Name: uzytkownicy_id_uzytkownika_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.uzytkownicy_id_uzytkownika_seq OWNED BY public.uzytkownicy.id_uzytkownika;


--
-- TOC entry 236 (class 1259 OID 16573)
-- Name: wyszukiwania; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wyszukiwania (
    id_wyszukiwania integer NOT NULL,
    id_uzytkownika integer,
    zapytanie character varying(255) NOT NULL,
    data_wyszukiwania timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.wyszukiwania OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16572)
-- Name: wyszukiwania_id_wyszukiwania_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.wyszukiwania_id_wyszukiwania_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.wyszukiwania_id_wyszukiwania_seq OWNER TO postgres;

--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 235
-- Name: wyszukiwania_id_wyszukiwania_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.wyszukiwania_id_wyszukiwania_seq OWNED BY public.wyszukiwania.id_wyszukiwania;


--
-- TOC entry 4924 (class 2604 OID 16489)
-- Name: kroki_przygotowania id_kroku; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kroki_przygotowania ALTER COLUMN id_kroku SET DEFAULT nextval('public.kroki_przygotowania_id_kroku_seq'::regclass);


--
-- TOC entry 4916 (class 2604 OID 16417)
-- Name: lokalizacje id_lokalizacji; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lokalizacje ALTER COLUMN id_lokalizacji SET DEFAULT nextval('public.lokalizacje_id_lokalizacji_seq'::regclass);


--
-- TOC entry 4921 (class 2604 OID 16470)
-- Name: przepisy id_przepisu; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.przepisy ALTER COLUMN id_przepisu SET DEFAULT nextval('public.przepisy_id_przepisu_seq'::regclass);


--
-- TOC entry 4919 (class 2604 OID 16448)
-- Name: skladniki id_skladnika; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skladniki ALTER COLUMN id_skladnika SET DEFAULT nextval('public.skladniki_id_skladnika_seq'::regclass);


--
-- TOC entry 4920 (class 2604 OID 16459)
-- Name: tagi id_tagu; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tagi ALTER COLUMN id_tagu SET DEFAULT nextval('public.tagi_id_tagu_seq'::regclass);


--
-- TOC entry 4917 (class 2604 OID 16427)
-- Name: uzytkownicy id_uzytkownika; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uzytkownicy ALTER COLUMN id_uzytkownika SET DEFAULT nextval('public.uzytkownicy_id_uzytkownika_seq'::regclass);


--
-- TOC entry 4927 (class 2604 OID 16576)
-- Name: wyszukiwania id_wyszukiwania; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wyszukiwania ALTER COLUMN id_wyszukiwania SET DEFAULT nextval('public.wyszukiwania_id_wyszukiwania_seq'::regclass);


--
-- TOC entry 5137 (class 0 OID 16486)
-- Dependencies: 230
-- Data for Name: kroki_przygotowania; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kroki_przygotowania (id_kroku, opis_kroku) FROM stdin;
1	Pokrój składnik na małe kawałki.
2	Smaż na rozgrzanym maśle przez 5 minut.
3	Gotuj makaron al dente.
4	Dodaj resztę składników i duś 10 minut.
5	Utrzyj masło z cukrem na puszystą masę.
6	Wylej na blachę i piecz w 180°C przez 30 minut.
\.


--
-- TOC entry 5145 (class 0 OID 16606)
-- Dependencies: 238
-- Data for Name: kroki_skladniki; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kroki_skladniki (id_przepisu, numer_kroku, id_skladnika) FROM stdin;
1	1	3
1	2	1
1	3	3
1	4	4
1	4	10
3	1	9
3	1	7
3	2	6
3	2	8
\.


--
-- TOC entry 5127 (class 0 OID 16414)
-- Dependencies: 220
-- Data for Name: lokalizacje; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lokalizacje (id_lokalizacji, kraj, wojewodztwo, miasto) FROM stdin;
1	Polska	Mazowieckie	Warszawa
2	Polska	Małopolskie	Kraków
3	Polska	Śląskie	Katowice
4	Polska	Dolnośląskie	Wrocław
5	Polska	Podkarpackie	Rzeszów
\.


--
-- TOC entry 5140 (class 0 OID 16532)
-- Dependencies: 233
-- Data for Name: oceny; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oceny (id_przepisu, id_uzytkownika, ocena, data_dodania) FROM stdin;
1	2	5	2025-11-24 00:27:12.007669
1	3	4	2025-11-24 00:27:12.007669
1	4	5	2025-11-24 00:27:12.007669
2	1	5	2025-11-24 00:27:12.007669
2	5	4	2025-11-24 00:27:12.007669
\.


--
-- TOC entry 5135 (class 0 OID 16467)
-- Dependencies: 228
-- Data for Name: przepisy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.przepisy (id_przepisu, id_uzytkownika, nazwa, czas_przygotowania, liczba_porcji, data_utworzenia, status) FROM stdin;
1	1	Penne ze szpinakiem i kurczakiem	30	4	2025-10-01	PUBLICZNY
2	2	Prosty sos pomidorowy	20	3	2025-10-15	PUBLICZNY
3	3	Ciasto marchewkowe	60	8	2025-11-01	PRYWATNY
4	4	Szybki omlet	10	1	2025-11-10	PUBLICZNY
5	5	Wegańska zupa dyniowa	45	6	2025-11-20	PUBLICZNY
\.


--
-- TOC entry 5144 (class 0 OID 16588)
-- Dependencies: 237
-- Data for Name: przepisy_kroki; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.przepisy_kroki (id_przepisu, numer_kroku, id_kroku, czas_trwania_minuty) FROM stdin;
1	1	1	5
1	2	3	10
1	3	2	5
1	4	4	10
3	1	5	10
3	2	6	30
\.


--
-- TOC entry 5139 (class 0 OID 16513)
-- Dependencies: 232
-- Data for Name: przepisy_skladniki; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.przepisy_skladniki (id_przepisu, id_skladnika, ilosc, jednostka) FROM stdin;
1	1	300.00	g
1	3	400.00	g
1	4	150.00	ml
1	10	200.00	g
2	2	50.00	g
2	5	400.00	g
3	6	250.00	g
3	7	200.00	g
3	8	3.00	szt
3	9	100.00	g
4	8	2.00	szt
4	9	5.00	g
5	5	500.00	g
5	2	100.00	g
\.


--
-- TOC entry 5138 (class 0 OID 16496)
-- Dependencies: 231
-- Data for Name: przepisy_tagi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.przepisy_tagi (id_przepisu, id_tagu) FROM stdin;
1	3
1	4
1	5
2	2
2	3
5	1
\.


--
-- TOC entry 5131 (class 0 OID 16445)
-- Dependencies: 224
-- Data for Name: skladniki; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.skladniki (id_skladnika, nazwa, kalorycznosc_na_100g, koszt_jednostkowy_pln) FROM stdin;
1	Makaron Penne	350.00	0.70
2	Cebula	40.00	0.15
3	Pierś kurczaka	165.00	3.50
4	Śmietana 30%	290.00	1.80
5	Pomidory krojone puszka	25.00	0.45
6	Mąka pszenna	364.00	0.10
7	Cukier	400.00	0.25
8	Jajka	140.00	0.90
9	Masło	717.00	4.00
10	Szpinak świeży	23.00	2.00
\.


--
-- TOC entry 5133 (class 0 OID 16456)
-- Dependencies: 226
-- Data for Name: tagi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tagi (id_tagu, nazwa) FROM stdin;
1	Wegańskie
2	Włoskie
3	Szybki obiad
4	Dla studenta
5	Fit
6	Deser
\.


--
-- TOC entry 5141 (class 0 OID 16553)
-- Dependencies: 234
-- Data for Name: ulubione; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ulubione (id_przepisu, id_uzytkownika, data_dodania) FROM stdin;
1	2	2025-11-24 00:27:12.007669
1	4	2025-11-24 00:27:12.007669
2	1	2025-11-24 00:27:12.007669
4	3	2025-11-24 00:27:12.007669
5	5	2025-11-24 00:27:12.007669
\.


--
-- TOC entry 5129 (class 0 OID 16424)
-- Dependencies: 222
-- Data for Name: uzytkownicy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.uzytkownicy (id_uzytkownika, imie, nazwisko, nazwa_uzytkownika, email, data_rejestracji, rok_urodzenia, id_lokalizacji) FROM stdin;
1	Anna	Wesoła	AnkaGotuje	anna.w@test.pl	2025-11-24	1995	1
2	Paweł	Górny	GornikChef	pawelg@test.pl	2025-11-24	1988	3
3	Monika	Kaczmarczyk	MoniaK	monia.k@test.pl	2025-11-24	2000	2
4	Krzysztof	Zając	KrisZajac	krisz@test.pl	2025-11-24	1992	4
5	Ewa	Słoń	SłonikEwa	ewa.slon@test.pl	2025-11-24	1975	5
\.


--
-- TOC entry 5143 (class 0 OID 16573)
-- Dependencies: 236
-- Data for Name: wyszukiwania; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wyszukiwania (id_wyszukiwania, id_uzytkownika, zapytanie, data_wyszukiwania) FROM stdin;
\.


--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 229
-- Name: kroki_przygotowania_id_kroku_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kroki_przygotowania_id_kroku_seq', 6, true);


--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 219
-- Name: lokalizacje_id_lokalizacji_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lokalizacje_id_lokalizacji_seq', 5, true);


--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 227
-- Name: przepisy_id_przepisu_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.przepisy_id_przepisu_seq', 5, true);


--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 223
-- Name: skladniki_id_skladnika_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.skladniki_id_skladnika_seq', 10, true);


--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 225
-- Name: tagi_id_tagu_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tagi_id_tagu_seq', 6, true);


--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 221
-- Name: uzytkownicy_id_uzytkownika_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.uzytkownicy_id_uzytkownika_seq', 5, true);


--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 235
-- Name: wyszukiwania_id_wyszukiwania_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.wyszukiwania_id_wyszukiwania_seq', 1, false);


--
-- TOC entry 4949 (class 2606 OID 16495)
-- Name: kroki_przygotowania kroki_przygotowania_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kroki_przygotowania
    ADD CONSTRAINT kroki_przygotowania_pkey PRIMARY KEY (id_kroku);


--
-- TOC entry 4963 (class 2606 OID 16613)
-- Name: kroki_skladniki kroki_skladniki_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kroki_skladniki
    ADD CONSTRAINT kroki_skladniki_pkey PRIMARY KEY (id_przepisu, numer_kroku, id_skladnika);


--
-- TOC entry 4931 (class 2606 OID 16422)
-- Name: lokalizacje lokalizacje_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lokalizacje
    ADD CONSTRAINT lokalizacje_pkey PRIMARY KEY (id_lokalizacji);


--
-- TOC entry 4955 (class 2606 OID 16542)
-- Name: oceny oceny_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oceny
    ADD CONSTRAINT oceny_pkey PRIMARY KEY (id_przepisu, id_uzytkownika);


--
-- TOC entry 4961 (class 2606 OID 16595)
-- Name: przepisy_kroki przepisy_kroki_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.przepisy_kroki
    ADD CONSTRAINT przepisy_kroki_pkey PRIMARY KEY (id_przepisu, numer_kroku);


--
-- TOC entry 4947 (class 2606 OID 16479)
-- Name: przepisy przepisy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.przepisy
    ADD CONSTRAINT przepisy_pkey PRIMARY KEY (id_przepisu);


--
-- TOC entry 4953 (class 2606 OID 16521)
-- Name: przepisy_skladniki przepisy_skladniki_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.przepisy_skladniki
    ADD CONSTRAINT przepisy_skladniki_pkey PRIMARY KEY (id_przepisu, id_skladnika);


--
-- TOC entry 4951 (class 2606 OID 16502)
-- Name: przepisy_tagi przepisy_tagi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.przepisy_tagi
    ADD CONSTRAINT przepisy_tagi_pkey PRIMARY KEY (id_przepisu, id_tagu);


--
-- TOC entry 4939 (class 2606 OID 16454)
-- Name: skladniki skladniki_nazwa_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skladniki
    ADD CONSTRAINT skladniki_nazwa_key UNIQUE (nazwa);


--
-- TOC entry 4941 (class 2606 OID 16452)
-- Name: skladniki skladniki_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skladniki
    ADD CONSTRAINT skladniki_pkey PRIMARY KEY (id_skladnika);


--
-- TOC entry 4943 (class 2606 OID 16465)
-- Name: tagi tagi_nazwa_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tagi
    ADD CONSTRAINT tagi_nazwa_key UNIQUE (nazwa);


--
-- TOC entry 4945 (class 2606 OID 16463)
-- Name: tagi tagi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tagi
    ADD CONSTRAINT tagi_pkey PRIMARY KEY (id_tagu);


--
-- TOC entry 4957 (class 2606 OID 16561)
-- Name: ulubione ulubione_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ulubione
    ADD CONSTRAINT ulubione_pkey PRIMARY KEY (id_przepisu, id_uzytkownika);


--
-- TOC entry 4933 (class 2606 OID 16438)
-- Name: uzytkownicy uzytkownicy_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uzytkownicy
    ADD CONSTRAINT uzytkownicy_email_key UNIQUE (email);


--
-- TOC entry 4935 (class 2606 OID 16436)
-- Name: uzytkownicy uzytkownicy_nazwa_uzytkownika_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uzytkownicy
    ADD CONSTRAINT uzytkownicy_nazwa_uzytkownika_key UNIQUE (nazwa_uzytkownika);


--
-- TOC entry 4937 (class 2606 OID 16434)
-- Name: uzytkownicy uzytkownicy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uzytkownicy
    ADD CONSTRAINT uzytkownicy_pkey PRIMARY KEY (id_uzytkownika);


--
-- TOC entry 4959 (class 2606 OID 16582)
-- Name: wyszukiwania wyszukiwania_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wyszukiwania
    ADD CONSTRAINT wyszukiwania_pkey PRIMARY KEY (id_wyszukiwania);


--
-- TOC entry 4977 (class 2606 OID 16614)
-- Name: kroki_skladniki kroki_skladniki_id_przepisu_numer_kroku_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kroki_skladniki
    ADD CONSTRAINT kroki_skladniki_id_przepisu_numer_kroku_fkey FOREIGN KEY (id_przepisu, numer_kroku) REFERENCES public.przepisy_kroki(id_przepisu, numer_kroku) ON DELETE CASCADE;


--
-- TOC entry 4978 (class 2606 OID 16619)
-- Name: kroki_skladniki kroki_skladniki_id_skladnika_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kroki_skladniki
    ADD CONSTRAINT kroki_skladniki_id_skladnika_fkey FOREIGN KEY (id_skladnika) REFERENCES public.skladniki(id_skladnika) ON DELETE RESTRICT;


--
-- TOC entry 4970 (class 2606 OID 16543)
-- Name: oceny oceny_id_przepisu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oceny
    ADD CONSTRAINT oceny_id_przepisu_fkey FOREIGN KEY (id_przepisu) REFERENCES public.przepisy(id_przepisu) ON DELETE CASCADE;


--
-- TOC entry 4971 (class 2606 OID 16548)
-- Name: oceny oceny_id_uzytkownika_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oceny
    ADD CONSTRAINT oceny_id_uzytkownika_fkey FOREIGN KEY (id_uzytkownika) REFERENCES public.uzytkownicy(id_uzytkownika) ON DELETE CASCADE;


--
-- TOC entry 4965 (class 2606 OID 16480)
-- Name: przepisy przepisy_id_uzytkownika_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.przepisy
    ADD CONSTRAINT przepisy_id_uzytkownika_fkey FOREIGN KEY (id_uzytkownika) REFERENCES public.uzytkownicy(id_uzytkownika);


--
-- TOC entry 4975 (class 2606 OID 16601)
-- Name: przepisy_kroki przepisy_kroki_id_kroku_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.przepisy_kroki
    ADD CONSTRAINT przepisy_kroki_id_kroku_fkey FOREIGN KEY (id_kroku) REFERENCES public.kroki_przygotowania(id_kroku) ON DELETE RESTRICT;


--
-- TOC entry 4976 (class 2606 OID 16596)
-- Name: przepisy_kroki przepisy_kroki_id_przepisu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.przepisy_kroki
    ADD CONSTRAINT przepisy_kroki_id_przepisu_fkey FOREIGN KEY (id_przepisu) REFERENCES public.przepisy(id_przepisu) ON DELETE CASCADE;


--
-- TOC entry 4968 (class 2606 OID 16522)
-- Name: przepisy_skladniki przepisy_skladniki_id_przepisu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.przepisy_skladniki
    ADD CONSTRAINT przepisy_skladniki_id_przepisu_fkey FOREIGN KEY (id_przepisu) REFERENCES public.przepisy(id_przepisu) ON DELETE CASCADE;


--
-- TOC entry 4969 (class 2606 OID 16527)
-- Name: przepisy_skladniki przepisy_skladniki_id_skladnika_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.przepisy_skladniki
    ADD CONSTRAINT przepisy_skladniki_id_skladnika_fkey FOREIGN KEY (id_skladnika) REFERENCES public.skladniki(id_skladnika) ON DELETE RESTRICT;


--
-- TOC entry 4966 (class 2606 OID 16503)
-- Name: przepisy_tagi przepisy_tagi_id_przepisu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.przepisy_tagi
    ADD CONSTRAINT przepisy_tagi_id_przepisu_fkey FOREIGN KEY (id_przepisu) REFERENCES public.przepisy(id_przepisu) ON DELETE CASCADE;


--
-- TOC entry 4967 (class 2606 OID 16508)
-- Name: przepisy_tagi przepisy_tagi_id_tagu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.przepisy_tagi
    ADD CONSTRAINT przepisy_tagi_id_tagu_fkey FOREIGN KEY (id_tagu) REFERENCES public.tagi(id_tagu) ON DELETE CASCADE;


--
-- TOC entry 4972 (class 2606 OID 16562)
-- Name: ulubione ulubione_id_przepisu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ulubione
    ADD CONSTRAINT ulubione_id_przepisu_fkey FOREIGN KEY (id_przepisu) REFERENCES public.przepisy(id_przepisu) ON DELETE CASCADE;


--
-- TOC entry 4973 (class 2606 OID 16567)
-- Name: ulubione ulubione_id_uzytkownika_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ulubione
    ADD CONSTRAINT ulubione_id_uzytkownika_fkey FOREIGN KEY (id_uzytkownika) REFERENCES public.uzytkownicy(id_uzytkownika) ON DELETE CASCADE;


--
-- TOC entry 4964 (class 2606 OID 16439)
-- Name: uzytkownicy uzytkownicy_id_lokalizacji_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uzytkownicy
    ADD CONSTRAINT uzytkownicy_id_lokalizacji_fkey FOREIGN KEY (id_lokalizacji) REFERENCES public.lokalizacje(id_lokalizacji);


--
-- TOC entry 4974 (class 2606 OID 16583)
-- Name: wyszukiwania wyszukiwania_id_uzytkownika_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wyszukiwania
    ADD CONSTRAINT wyszukiwania_id_uzytkownika_fkey FOREIGN KEY (id_uzytkownika) REFERENCES public.uzytkownicy(id_uzytkownika) ON DELETE SET NULL;


-- Completed on 2025-11-24 08:39:55

--
-- PostgreSQL database dump complete
--

\unrestrict J8LKvHSFiz2RolwGzF0dFGgOBNBmQvI0Fo1yVgqCdeMLrHSY4BDGNDBNGPcPtKN

