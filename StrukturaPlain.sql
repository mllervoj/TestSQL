--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2024-12-17 10:41:55

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
-- TOC entry 4948 (class 1262 OID 16388)
-- Name: test; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE test WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Czech_Czechia.1250';


ALTER DATABASE test OWNER TO postgres;

\connect test

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
-- TOC entry 6 (class 2615 OID 16389)
-- Name: data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA data;


ALTER SCHEMA data OWNER TO postgres;

--
-- TOC entry 4949 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA data; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA data IS 'data';


--
-- TOC entry 861 (class 1247 OID 16586)
-- Name: funkce; Type: TYPE; Schema: data; Owner: postgres
--

CREATE TYPE data.funkce AS ENUM (
    'jednatel',
    'reditel',
    'technicky_pracovnik',
    'ekonom',
    'recepcni'
);


ALTER TYPE data.funkce OWNER TO postgres;

--
-- TOC entry 858 (class 1247 OID 16578)
-- Name: typ; Type: TYPE; Schema: data; Owner: postgres
--

CREATE TYPE data.typ AS ENUM (
    'reditelstvi',
    'pobocka',
    'zahranicni_pobocka'
);


ALTER TYPE data.typ OWNER TO postgres;

--
-- TOC entry 855 (class 1247 OID 16482)
-- Name: typ; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.typ AS ENUM (
    'reditelstvi',
    'pobocka',
    'zahranicni_pobocka'
);


ALTER TYPE public.typ OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 16709)
-- Name: insertreditelstvijednatel(); Type: FUNCTION; Schema: data; Owner: postgres
--

CREATE FUNCTION data.insertreditelstvijednatel() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
		INSERT INTO data.Sidla (nazev, typ, adresa_stat, adresa_obec, adresa_ulice)
			VALUES ('nezname', 'reditelstvi', 'nezname', 'nezname', 'nezname');
			
		INSERT INTO data.Osoby (jmeno, prijmeni, funkce)
			VALUES ('nezname', 'nezname', 'jednatel');

		INSERT INTO data.Sidla_Spolecnosti (sidloID, spolecnostID)
			VALUES(
				(SELECT max(sidloID) FROM data.Sidla),
				(SELECT max(spolecnostID) FROM data.Spolecnosti)
				);
	
		INSERT INTO data.Osoby_Spolecnosti_Sidla (osobaID, spolecnostID, sidloID)
			VALUES(
				(SELECT max(osobaID) FROM data.Osoby),
				(SELECT max(spolecnostID) FROM data.Spolecnosti),
				(SELECT max(sidloID) FROM data.Sidla)
				);
		
		RETURN new;
	END;
	$$;


ALTER FUNCTION data.insertreditelstvijednatel() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 16611)
-- Name: osoby; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.osoby (
    osobaid integer NOT NULL,
    jmeno character varying(255),
    prijmeni character varying(255),
    funkce data.funkce
);


ALTER TABLE data.osoby OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16610)
-- Name: osoby_osobaid_seq; Type: SEQUENCE; Schema: data; Owner: postgres
--

CREATE SEQUENCE data.osoby_osobaid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE data.osoby_osobaid_seq OWNER TO postgres;

--
-- TOC entry 4950 (class 0 OID 0)
-- Dependencies: 218
-- Name: osoby_osobaid_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE data.osoby_osobaid_seq OWNED BY data.osoby.osobaid;


--
-- TOC entry 225 (class 1259 OID 16688)
-- Name: osoby_spolecnosti_sidla; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.osoby_spolecnosti_sidla (
    osobaid integer NOT NULL,
    spolecnostid integer NOT NULL,
    sidloid integer NOT NULL
);


ALTER TABLE data.osoby_spolecnosti_sidla OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16625)
-- Name: sidla; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.sidla (
    sidloid integer NOT NULL,
    nazev character varying(255),
    typ data.typ,
    adresa_stat character varying(255),
    adresa_obec character varying(255),
    adresa_ulice character varying(255),
    adresa_c_d integer,
    adresa_c_o integer,
    adresa_psc integer,
    CONSTRAINT sidla_adresa_psc_check CHECK (((adresa_psc >= 10000) AND (adresa_psc <= 99999)))
);


ALTER TABLE data.sidla OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16624)
-- Name: sidla_sidloid_seq; Type: SEQUENCE; Schema: data; Owner: postgres
--

CREATE SEQUENCE data.sidla_sidloid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE data.sidla_sidloid_seq OWNER TO postgres;

--
-- TOC entry 4951 (class 0 OID 0)
-- Dependencies: 220
-- Name: sidla_sidloid_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE data.sidla_sidloid_seq OWNED BY data.sidla.sidloid;


--
-- TOC entry 224 (class 1259 OID 16675)
-- Name: sidla_spolecnosti; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.sidla_spolecnosti (
    sidloid integer NOT NULL,
    spolecnostid integer NOT NULL
);


ALTER TABLE data.sidla_spolecnosti OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16666)
-- Name: spolecnosti; Type: TABLE; Schema: data; Owner: postgres
--

CREATE TABLE data.spolecnosti (
    spolecnostid integer NOT NULL,
    nazev character varying(255),
    ico integer,
    CONSTRAINT spolecnosti_ico_check CHECK (((ico >= 10000000) AND (ico <= 99999999)))
);


ALTER TABLE data.spolecnosti OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16665)
-- Name: spolecnosti_spolecnostid_seq; Type: SEQUENCE; Schema: data; Owner: postgres
--

CREATE SEQUENCE data.spolecnosti_spolecnostid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE data.spolecnosti_spolecnostid_seq OWNER TO postgres;

--
-- TOC entry 4952 (class 0 OID 0)
-- Dependencies: 222
-- Name: spolecnosti_spolecnostid_seq; Type: SEQUENCE OWNED BY; Schema: data; Owner: postgres
--

ALTER SEQUENCE data.spolecnosti_spolecnostid_seq OWNED BY data.spolecnosti.spolecnostid;


--
-- TOC entry 4771 (class 2604 OID 16614)
-- Name: osoby osobaid; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.osoby ALTER COLUMN osobaid SET DEFAULT nextval('data.osoby_osobaid_seq'::regclass);


--
-- TOC entry 4772 (class 2604 OID 16628)
-- Name: sidla sidloid; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.sidla ALTER COLUMN sidloid SET DEFAULT nextval('data.sidla_sidloid_seq'::regclass);


--
-- TOC entry 4773 (class 2604 OID 16669)
-- Name: spolecnosti spolecnostid; Type: DEFAULT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.spolecnosti ALTER COLUMN spolecnostid SET DEFAULT nextval('data.spolecnosti_spolecnostid_seq'::regclass);


--
-- TOC entry 4936 (class 0 OID 16611)
-- Dependencies: 219
-- Data for Name: osoby; Type: TABLE DATA; Schema: data; Owner: postgres
--

COPY data.osoby (osobaid, jmeno, prijmeni, funkce) FROM stdin;
1	Jan	Svoboda	jednatel
2	Jiří	Novák	reditel
3	Jana	Stará	ekonom
4	Josef	Novotný	jednatel
5	Petra	Kovářová	reditel
6	Daniel	Hrdlička	jednatel
7	Hana	Řezníková	reditel
\.


--
-- TOC entry 4942 (class 0 OID 16688)
-- Dependencies: 225
-- Data for Name: osoby_spolecnosti_sidla; Type: TABLE DATA; Schema: data; Owner: postgres
--

COPY data.osoby_spolecnosti_sidla (osobaid, spolecnostid, sidloid) FROM stdin;
1	1	1
2	1	1
3	1	2
4	2	4
5	2	4
6	3	6
7	3	6
\.


--
-- TOC entry 4938 (class 0 OID 16625)
-- Dependencies: 221
-- Data for Name: sidla; Type: TABLE DATA; Schema: data; Owner: postgres
--

COPY data.sidla (sidloid, nazev, typ, adresa_stat, adresa_obec, adresa_ulice, adresa_c_d, adresa_c_o, adresa_psc) FROM stdin;
1	sidloA1	reditelstvi	Česká republika	Praha 6 - Dejvice	Thákurava	2077	7	16000
2	sidloA2	pobocka	Česká republika	Praha 6 - Dejvice	Technická	2710	6	16000
3	sidloA3	pobocka	Česká republika	Praha 6 - Dejvice	Technická	1905	5	16000
4	sidloB1	reditelstvi	Česká republika	Praha 11 - Chodov	Roztylská	2321	19	14800
5	sidloB2	pobocka	Česká republika	Praha 11 - Chodov	Šustova	1930	2	14800
6	sidloC1	reditelstvi	Česká republika	Praha 13 - Stodůlky	Za Lužinami	1084	33	15500
\.


--
-- TOC entry 4941 (class 0 OID 16675)
-- Dependencies: 224
-- Data for Name: sidla_spolecnosti; Type: TABLE DATA; Schema: data; Owner: postgres
--

COPY data.sidla_spolecnosti (sidloid, spolecnostid) FROM stdin;
1	1
2	1
3	1
4	2
5	2
6	3
\.


--
-- TOC entry 4940 (class 0 OID 16666)
-- Dependencies: 223
-- Data for Name: spolecnosti; Type: TABLE DATA; Schema: data; Owner: postgres
--

COPY data.spolecnosti (spolecnostid, nazev, ico) FROM stdin;
1	firmaA	45746124
2	firmaB	64815348
3	firmaC	84561618
\.


--
-- TOC entry 4953 (class 0 OID 0)
-- Dependencies: 218
-- Name: osoby_osobaid_seq; Type: SEQUENCE SET; Schema: data; Owner: postgres
--

SELECT pg_catalog.setval('data.osoby_osobaid_seq', 10, true);


--
-- TOC entry 4954 (class 0 OID 0)
-- Dependencies: 220
-- Name: sidla_sidloid_seq; Type: SEQUENCE SET; Schema: data; Owner: postgres
--

SELECT pg_catalog.setval('data.sidla_sidloid_seq', 9, true);


--
-- TOC entry 4955 (class 0 OID 0)
-- Dependencies: 222
-- Name: spolecnosti_spolecnostid_seq; Type: SEQUENCE SET; Schema: data; Owner: postgres
--

SELECT pg_catalog.setval('data.spolecnosti_spolecnostid_seq', 7, true);


--
-- TOC entry 4777 (class 2606 OID 16618)
-- Name: osoby osoby_pkey; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.osoby
    ADD CONSTRAINT osoby_pkey PRIMARY KEY (osobaid);


--
-- TOC entry 4779 (class 2606 OID 16633)
-- Name: sidla sidla_pkey; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.sidla
    ADD CONSTRAINT sidla_pkey PRIMARY KEY (sidloid);


--
-- TOC entry 4781 (class 2606 OID 16674)
-- Name: spolecnosti spolecnosti_ico_key; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.spolecnosti
    ADD CONSTRAINT spolecnosti_ico_key UNIQUE (ico);


--
-- TOC entry 4783 (class 2606 OID 16672)
-- Name: spolecnosti spolecnosti_pkey; Type: CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.spolecnosti
    ADD CONSTRAINT spolecnosti_pkey PRIMARY KEY (spolecnostid);


--
-- TOC entry 4789 (class 2620 OID 16710)
-- Name: spolecnosti reditelstvijednatel; Type: TRIGGER; Schema: data; Owner: postgres
--

CREATE TRIGGER reditelstvijednatel AFTER INSERT ON data.spolecnosti FOR EACH STATEMENT EXECUTE FUNCTION data.insertreditelstvijednatel();


--
-- TOC entry 4786 (class 2606 OID 16691)
-- Name: osoby_spolecnosti_sidla osoby_spolecnosti_sidla_osobaid_fkey; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.osoby_spolecnosti_sidla
    ADD CONSTRAINT osoby_spolecnosti_sidla_osobaid_fkey FOREIGN KEY (osobaid) REFERENCES data.osoby(osobaid);


--
-- TOC entry 4787 (class 2606 OID 16701)
-- Name: osoby_spolecnosti_sidla osoby_spolecnosti_sidla_sidloid_fkey; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.osoby_spolecnosti_sidla
    ADD CONSTRAINT osoby_spolecnosti_sidla_sidloid_fkey FOREIGN KEY (sidloid) REFERENCES data.sidla(sidloid);


--
-- TOC entry 4788 (class 2606 OID 16696)
-- Name: osoby_spolecnosti_sidla osoby_spolecnosti_sidla_spolecnostid_fkey; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.osoby_spolecnosti_sidla
    ADD CONSTRAINT osoby_spolecnosti_sidla_spolecnostid_fkey FOREIGN KEY (spolecnostid) REFERENCES data.spolecnosti(spolecnostid);


--
-- TOC entry 4784 (class 2606 OID 16678)
-- Name: sidla_spolecnosti sidla_spolecnosti_sidloid_fkey; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.sidla_spolecnosti
    ADD CONSTRAINT sidla_spolecnosti_sidloid_fkey FOREIGN KEY (sidloid) REFERENCES data.sidla(sidloid);


--
-- TOC entry 4785 (class 2606 OID 16683)
-- Name: sidla_spolecnosti sidla_spolecnosti_spolecnostid_fkey; Type: FK CONSTRAINT; Schema: data; Owner: postgres
--

ALTER TABLE ONLY data.sidla_spolecnosti
    ADD CONSTRAINT sidla_spolecnosti_spolecnostid_fkey FOREIGN KEY (spolecnostid) REFERENCES data.spolecnosti(spolecnostid);


-- Completed on 2024-12-17 10:41:56

--
-- PostgreSQL database dump complete
--

