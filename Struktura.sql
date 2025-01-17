PGDMP          
            |            test    17.2    17.2 *    Q           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            R           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            S           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            T           1262    16388    test    DATABASE     w   CREATE DATABASE test WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Czech_Czechia.1250';
    DROP DATABASE test;
                     postgres    false                        2615    16389    data    SCHEMA        CREATE SCHEMA data;
    DROP SCHEMA data;
                     postgres    false            U           0    0    SCHEMA data    COMMENT     "   COMMENT ON SCHEMA data IS 'data';
                        postgres    false    6            ]           1247    16586    funkce    TYPE     |   CREATE TYPE data.funkce AS ENUM (
    'jednatel',
    'reditel',
    'technicky_pracovnik',
    'ekonom',
    'recepcni'
);
    DROP TYPE data.funkce;
       data               postgres    false    6            Z           1247    16578    typ    TYPE     ]   CREATE TYPE data.typ AS ENUM (
    'reditelstvi',
    'pobocka',
    'zahranicni_pobocka'
);
    DROP TYPE data.typ;
       data               postgres    false    6            W           1247    16482    typ    TYPE     _   CREATE TYPE public.typ AS ENUM (
    'reditelstvi',
    'pobocka',
    'zahranicni_pobocka'
);
    DROP TYPE public.typ;
       public               postgres    false            �            1255    16709    insertreditelstvijednatel()    FUNCTION       CREATE FUNCTION data.insertreditelstvijednatel() RETURNS trigger
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
 0   DROP FUNCTION data.insertreditelstvijednatel();
       data               postgres    false    6            �            1259    16611    osoby    TABLE     �   CREATE TABLE data.osoby (
    osobaid integer NOT NULL,
    jmeno character varying(255),
    prijmeni character varying(255),
    funkce data.funkce
);
    DROP TABLE data.osoby;
       data         heap r       postgres    false    861    6            �            1259    16610    osoby_osobaid_seq    SEQUENCE     �   CREATE SEQUENCE data.osoby_osobaid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE data.osoby_osobaid_seq;
       data               postgres    false    6    219            V           0    0    osoby_osobaid_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE data.osoby_osobaid_seq OWNED BY data.osoby.osobaid;
          data               postgres    false    218            �            1259    16688    osoby_spolecnosti_sidla    TABLE     �   CREATE TABLE data.osoby_spolecnosti_sidla (
    osobaid integer NOT NULL,
    spolecnostid integer NOT NULL,
    sidloid integer NOT NULL
);
 )   DROP TABLE data.osoby_spolecnosti_sidla;
       data         heap r       postgres    false    6            �            1259    16625    sidla    TABLE     �  CREATE TABLE data.sidla (
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
    DROP TABLE data.sidla;
       data         heap r       postgres    false    858    6            �            1259    16624    sidla_sidloid_seq    SEQUENCE     �   CREATE SEQUENCE data.sidla_sidloid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE data.sidla_sidloid_seq;
       data               postgres    false    6    221            W           0    0    sidla_sidloid_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE data.sidla_sidloid_seq OWNED BY data.sidla.sidloid;
          data               postgres    false    220            �            1259    16675    sidla_spolecnosti    TABLE     i   CREATE TABLE data.sidla_spolecnosti (
    sidloid integer NOT NULL,
    spolecnostid integer NOT NULL
);
 #   DROP TABLE data.sidla_spolecnosti;
       data         heap r       postgres    false    6            �            1259    16666    spolecnosti    TABLE     �   CREATE TABLE data.spolecnosti (
    spolecnostid integer NOT NULL,
    nazev character varying(255),
    ico integer,
    CONSTRAINT spolecnosti_ico_check CHECK (((ico >= 10000000) AND (ico <= 99999999)))
);
    DROP TABLE data.spolecnosti;
       data         heap r       postgres    false    6            �            1259    16665    spolecnosti_spolecnostid_seq    SEQUENCE     �   CREATE SEQUENCE data.spolecnosti_spolecnostid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE data.spolecnosti_spolecnostid_seq;
       data               postgres    false    6    223            X           0    0    spolecnosti_spolecnostid_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE data.spolecnosti_spolecnostid_seq OWNED BY data.spolecnosti.spolecnostid;
          data               postgres    false    222            �           2604    16614    osoby osobaid    DEFAULT     j   ALTER TABLE ONLY data.osoby ALTER COLUMN osobaid SET DEFAULT nextval('data.osoby_osobaid_seq'::regclass);
 :   ALTER TABLE data.osoby ALTER COLUMN osobaid DROP DEFAULT;
       data               postgres    false    218    219    219            �           2604    16628    sidla sidloid    DEFAULT     j   ALTER TABLE ONLY data.sidla ALTER COLUMN sidloid SET DEFAULT nextval('data.sidla_sidloid_seq'::regclass);
 :   ALTER TABLE data.sidla ALTER COLUMN sidloid DROP DEFAULT;
       data               postgres    false    221    220    221            �           2604    16669    spolecnosti spolecnostid    DEFAULT     �   ALTER TABLE ONLY data.spolecnosti ALTER COLUMN spolecnostid SET DEFAULT nextval('data.spolecnosti_spolecnostid_seq'::regclass);
 E   ALTER TABLE data.spolecnosti ALTER COLUMN spolecnostid DROP DEFAULT;
       data               postgres    false    223    222    223            H          0    16611    osoby 
   TABLE DATA           ?   COPY data.osoby (osobaid, jmeno, prijmeni, funkce) FROM stdin;
    data               postgres    false    219   ,4       N          0    16688    osoby_spolecnosti_sidla 
   TABLE DATA           O   COPY data.osoby_spolecnosti_sidla (osobaid, spolecnostid, sidloid) FROM stdin;
    data               postgres    false    225   �4       J          0    16625    sidla 
   TABLE DATA           ~   COPY data.sidla (sidloid, nazev, typ, adresa_stat, adresa_obec, adresa_ulice, adresa_c_d, adresa_c_o, adresa_psc) FROM stdin;
    data               postgres    false    221   5       M          0    16675    sidla_spolecnosti 
   TABLE DATA           @   COPY data.sidla_spolecnosti (sidloid, spolecnostid) FROM stdin;
    data               postgres    false    224   6       L          0    16666    spolecnosti 
   TABLE DATA           =   COPY data.spolecnosti (spolecnostid, nazev, ico) FROM stdin;
    data               postgres    false    223   16       Y           0    0    osoby_osobaid_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('data.osoby_osobaid_seq', 10, true);
          data               postgres    false    218            Z           0    0    sidla_sidloid_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('data.sidla_sidloid_seq', 9, true);
          data               postgres    false    220            [           0    0    spolecnosti_spolecnostid_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('data.spolecnosti_spolecnostid_seq', 7, true);
          data               postgres    false    222            �           2606    16618    osoby osoby_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY data.osoby
    ADD CONSTRAINT osoby_pkey PRIMARY KEY (osobaid);
 8   ALTER TABLE ONLY data.osoby DROP CONSTRAINT osoby_pkey;
       data                 postgres    false    219            �           2606    16633    sidla sidla_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY data.sidla
    ADD CONSTRAINT sidla_pkey PRIMARY KEY (sidloid);
 8   ALTER TABLE ONLY data.sidla DROP CONSTRAINT sidla_pkey;
       data                 postgres    false    221            �           2606    16674    spolecnosti spolecnosti_ico_key 
   CONSTRAINT     W   ALTER TABLE ONLY data.spolecnosti
    ADD CONSTRAINT spolecnosti_ico_key UNIQUE (ico);
 G   ALTER TABLE ONLY data.spolecnosti DROP CONSTRAINT spolecnosti_ico_key;
       data                 postgres    false    223            �           2606    16672    spolecnosti spolecnosti_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY data.spolecnosti
    ADD CONSTRAINT spolecnosti_pkey PRIMARY KEY (spolecnostid);
 D   ALTER TABLE ONLY data.spolecnosti DROP CONSTRAINT spolecnosti_pkey;
       data                 postgres    false    223            �           2620    16710    spolecnosti reditelstvijednatel    TRIGGER     �   CREATE TRIGGER reditelstvijednatel AFTER INSERT ON data.spolecnosti FOR EACH STATEMENT EXECUTE FUNCTION data.insertreditelstvijednatel();
 6   DROP TRIGGER reditelstvijednatel ON data.spolecnosti;
       data               postgres    false    237    223            �           2606    16691 <   osoby_spolecnosti_sidla osoby_spolecnosti_sidla_osobaid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY data.osoby_spolecnosti_sidla
    ADD CONSTRAINT osoby_spolecnosti_sidla_osobaid_fkey FOREIGN KEY (osobaid) REFERENCES data.osoby(osobaid);
 d   ALTER TABLE ONLY data.osoby_spolecnosti_sidla DROP CONSTRAINT osoby_spolecnosti_sidla_osobaid_fkey;
       data               postgres    false    4777    219    225            �           2606    16701 <   osoby_spolecnosti_sidla osoby_spolecnosti_sidla_sidloid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY data.osoby_spolecnosti_sidla
    ADD CONSTRAINT osoby_spolecnosti_sidla_sidloid_fkey FOREIGN KEY (sidloid) REFERENCES data.sidla(sidloid);
 d   ALTER TABLE ONLY data.osoby_spolecnosti_sidla DROP CONSTRAINT osoby_spolecnosti_sidla_sidloid_fkey;
       data               postgres    false    221    225    4779            �           2606    16696 A   osoby_spolecnosti_sidla osoby_spolecnosti_sidla_spolecnostid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY data.osoby_spolecnosti_sidla
    ADD CONSTRAINT osoby_spolecnosti_sidla_spolecnostid_fkey FOREIGN KEY (spolecnostid) REFERENCES data.spolecnosti(spolecnostid);
 i   ALTER TABLE ONLY data.osoby_spolecnosti_sidla DROP CONSTRAINT osoby_spolecnosti_sidla_spolecnostid_fkey;
       data               postgres    false    225    223    4783            �           2606    16678 0   sidla_spolecnosti sidla_spolecnosti_sidloid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY data.sidla_spolecnosti
    ADD CONSTRAINT sidla_spolecnosti_sidloid_fkey FOREIGN KEY (sidloid) REFERENCES data.sidla(sidloid);
 X   ALTER TABLE ONLY data.sidla_spolecnosti DROP CONSTRAINT sidla_spolecnosti_sidloid_fkey;
       data               postgres    false    221    224    4779            �           2606    16683 5   sidla_spolecnosti sidla_spolecnosti_spolecnostid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY data.sidla_spolecnosti
    ADD CONSTRAINT sidla_spolecnosti_spolecnostid_fkey FOREIGN KEY (spolecnostid) REFERENCES data.spolecnosti(spolecnostid);
 ]   ALTER TABLE ONLY data.sidla_spolecnosti DROP CONSTRAINT sidla_spolecnosti_spolecnostid_fkey;
       data               postgres    false    4783    223    224            H   �   x�U�=
1���a�/`�Da[�'yBL̃���n��#X��K���L1�|���N�bg6�{5����#v���!�����9�M� v��r�S�J
���,��	�J)}�j��M4޾��G�FS5����G��;L�Ro4�C�      N   +   x�3�4�4�2��@҈˄ӈӄ�L�qs�q���=... �p�      J   �   x���?N�0����@�?;�ڑbqK11u;��8=7`)���F��{?���i��&��1A[F��w��ӑ�z?l���z�*V�����������*T��s��$
����1;K�u�3u<����L�L��T�/P$-?k7��Erݺƍ�wo�`�o?)(��|�"�����M�.��V�C$�<[��d��k�O����0}��z5 ��!%�(��|�e����      M       x�3�4�2bc 6�4�2b3Nc�=... 4�z      L   :   x�3�L�,�Mt�41571342�2��8q��X��XpCD�9-LL��-�b���� �pu     