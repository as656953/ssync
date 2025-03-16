--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8
-- Dumped by pg_dump version 16.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: amenities; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.amenities (
    id integer NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    description text,
    max_capacity integer
);


ALTER TABLE public.amenities OWNER TO neondb_owner;

--
-- Name: amenities_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.amenities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.amenities_id_seq OWNER TO neondb_owner;

--
-- Name: amenities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.amenities_id_seq OWNED BY public.amenities.id;


--
-- Name: apartments; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.apartments (
    id integer NOT NULL,
    number text NOT NULL,
    tower_id integer NOT NULL,
    floor integer NOT NULL,
    type text NOT NULL,
    owner_name text,
    status text DEFAULT 'OCCUPIED'::text NOT NULL,
    monthly_rent numeric,
    sale_price numeric,
    contact_number text
);


ALTER TABLE public.apartments OWNER TO neondb_owner;

--
-- Name: apartments_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.apartments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.apartments_id_seq OWNER TO neondb_owner;

--
-- Name: apartments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.apartments_id_seq OWNED BY public.apartments.id;


--
-- Name: bookings; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.bookings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    amenity_id integer NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone NOT NULL,
    status text NOT NULL
);


ALTER TABLE public.bookings OWNER TO neondb_owner;

--
-- Name: bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.bookings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bookings_id_seq OWNER TO neondb_owner;

--
-- Name: bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.bookings_id_seq OWNED BY public.bookings.id;


--
-- Name: session; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.session (
    sid character varying NOT NULL,
    sess json NOT NULL,
    expire timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.session OWNER TO neondb_owner;

--
-- Name: towers; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.towers (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.towers OWNER TO neondb_owner;

--
-- Name: towers_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.towers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.towers_id_seq OWNER TO neondb_owner;

--
-- Name: towers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.towers_id_seq OWNED BY public.towers.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    is_admin boolean DEFAULT false NOT NULL,
    name text NOT NULL,
    apartment_id integer
);


ALTER TABLE public.users OWNER TO neondb_owner;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO neondb_owner;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: neondb_owner
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: amenities id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.amenities ALTER COLUMN id SET DEFAULT nextval('public.amenities_id_seq'::regclass);


--
-- Name: apartments id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.apartments ALTER COLUMN id SET DEFAULT nextval('public.apartments_id_seq'::regclass);


--
-- Name: bookings id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.bookings ALTER COLUMN id SET DEFAULT nextval('public.bookings_id_seq'::regclass);


--
-- Name: towers id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.towers ALTER COLUMN id SET DEFAULT nextval('public.towers_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: amenities; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.amenities (id, name, type, description, max_capacity) FROM stdin;
1	Gym	GYM	Fully equipped gymnasium	20
2	Guest House 1	GUEST_HOUSE	Guest accommodation	4
3	Guest House 2	GUEST_HOUSE	Guest accommodation	4
4	Guest House 3	GUEST_HOUSE	Guest accommodation	4
5	Guest House 4	GUEST_HOUSE	Guest accommodation	4
6	Clubhouse	CLUBHOUSE	Community gathering space	100
\.


--
-- Data for Name: apartments; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.apartments (id, number, tower_id, floor, type, owner_name, status, monthly_rent, sale_price, contact_number) FROM stdin;
705	101	1	1	2BHK	Owner 33	OCCUPIED	\N	\N	\N
706	102	1	1	2BHK	Owner 24	OCCUPIED	\N	\N	\N
707	103	1	1	2BHK	Owner 56	AVAILABLE_RENT	38000	\N	+91 9268445482
708	104	1	1	2BHK	Available	OCCUPIED	\N	\N	\N
709	201	1	2	2BHK	Owner 27	OCCUPIED	\N	\N	\N
710	202	1	2	2BHK	Owner 45	OCCUPIED	\N	\N	\N
711	203	1	2	2BHK	Owner 5	OCCUPIED	\N	\N	\N
712	204	1	2	2BHK	Owner 56	OCCUPIED	\N	\N	\N
713	301	1	3	2BHK	Owner 88	OCCUPIED	\N	\N	\N
714	302	1	3	2BHK	Owner 82	OCCUPIED	\N	\N	\N
715	303	1	3	2BHK	Owner 7	OCCUPIED	\N	\N	\N
716	304	1	3	2BHK	Available	OCCUPIED	\N	\N	\N
717	401	1	4	2BHK	Available	OCCUPIED	\N	\N	\N
718	402	1	4	2BHK	Available	OCCUPIED	\N	\N	\N
719	403	1	4	2BHK	Owner 96	AVAILABLE_SALE	\N	11000000	+91 9191338009
720	404	1	4	2BHK	Owner 61	AVAILABLE_RENT	36000	\N	+91 9705027334
721	501	1	5	2BHK	Owner 34	OCCUPIED	\N	\N	\N
722	502	1	5	2BHK	Owner 54	OCCUPIED	\N	\N	\N
723	503	1	5	2BHK	Available	OCCUPIED	\N	\N	\N
724	504	1	5	2BHK	Owner 30	AVAILABLE_RENT	46000	\N	+91 9158225934
725	601	1	6	3BHK	Available	OCCUPIED	\N	\N	\N
726	602	1	6	3BHK	Owner 55	OCCUPIED	\N	\N	\N
727	101	2	1	2BHK	Owner 92	OCCUPIED	\N	\N	\N
728	102	2	1	2BHK	Owner 63	OCCUPIED	\N	\N	\N
729	103	2	1	2BHK	Owner 10	AVAILABLE_SALE	\N	12700000	+91 9733051614
730	104	2	1	2BHK	Owner 70	OCCUPIED	\N	\N	\N
731	201	2	2	2BHK	Owner 41	OCCUPIED	\N	\N	\N
732	202	2	2	2BHK	Available	AVAILABLE_SALE	\N	8000000	+91 9902392108
733	203	2	2	2BHK	Owner 0	OCCUPIED	\N	\N	\N
734	204	2	2	2BHK	Owner 80	AVAILABLE_SALE	\N	11400000	+91 9605528570
735	301	2	3	2BHK	Owner 17	OCCUPIED	\N	\N	\N
736	302	2	3	2BHK	Owner 16	AVAILABLE_SALE	\N	8000000	+91 9229642715
737	303	2	3	2BHK	Available	AVAILABLE_RENT	39000	\N	+91 9548422522
738	304	2	3	2BHK	Owner 56	OCCUPIED	\N	\N	\N
739	401	2	4	2BHK	Owner 66	AVAILABLE_SALE	\N	9200000	+91 9409518410
740	402	2	4	2BHK	Available	AVAILABLE_SALE	\N	11000000	+91 9417459962
741	403	2	4	2BHK	Owner 77	OCCUPIED	\N	\N	\N
742	404	2	4	2BHK	Owner 90	AVAILABLE_RENT	37000	\N	+91 9653753488
743	501	2	5	2BHK	Available	OCCUPIED	\N	\N	\N
744	502	2	5	2BHK	Available	OCCUPIED	\N	\N	\N
745	503	2	5	2BHK	Available	OCCUPIED	\N	\N	\N
746	504	2	5	2BHK	Owner 9	OCCUPIED	\N	\N	\N
747	601	2	6	3BHK	Available	OCCUPIED	\N	\N	\N
748	602	2	6	3BHK	Owner 42	OCCUPIED	\N	\N	\N
749	101	3	1	2BHK	Owner 3	OCCUPIED	\N	\N	\N
750	102	3	1	2BHK	Owner 4	OCCUPIED	\N	\N	\N
751	103	3	1	2BHK	Owner 83	AVAILABLE_RENT	46000	\N	+91 9908392063
752	104	3	1	2BHK	Available	AVAILABLE_RENT	40000	\N	+91 9194215263
753	201	3	2	2BHK	Available	OCCUPIED	\N	\N	\N
754	202	3	2	2BHK	Owner 32	AVAILABLE_SALE	\N	8800000	+91 9766695513
755	203	3	2	2BHK	Owner 70	OCCUPIED	\N	\N	\N
756	204	3	2	2BHK	Available	OCCUPIED	\N	\N	\N
757	301	3	3	2BHK	Available	OCCUPIED	\N	\N	\N
758	302	3	3	2BHK	Available	OCCUPIED	\N	\N	\N
759	303	3	3	2BHK	Available	OCCUPIED	\N	\N	\N
760	304	3	3	2BHK	Owner 13	OCCUPIED	\N	\N	\N
761	401	3	4	2BHK	Owner 97	AVAILABLE_SALE	\N	12700000	+91 9335714440
762	402	3	4	2BHK	Available	OCCUPIED	\N	\N	\N
763	403	3	4	2BHK	Owner 41	OCCUPIED	\N	\N	\N
764	404	3	4	2BHK	Available	OCCUPIED	\N	\N	\N
765	501	3	5	2BHK	Available	AVAILABLE_SALE	\N	11500000	+91 9932410088
766	502	3	5	2BHK	Owner 27	OCCUPIED	\N	\N	\N
767	503	3	5	2BHK	Owner 29	AVAILABLE_RENT	43000	\N	+91 9210257741
768	504	3	5	2BHK	Owner 45	OCCUPIED	\N	\N	\N
769	601	3	6	3BHK	Owner 67	AVAILABLE_SALE	\N	15100000	+91 9661253959
770	602	3	6	3BHK	Available	OCCUPIED	\N	\N	\N
771	101	4	1	2BHK	Owner 17	OCCUPIED	\N	\N	\N
772	102	4	1	2BHK	Available	OCCUPIED	\N	\N	\N
773	103	4	1	2BHK	Owner 39	OCCUPIED	\N	\N	\N
774	104	4	1	2BHK	Available	OCCUPIED	\N	\N	\N
775	201	4	2	2BHK	Owner 11	OCCUPIED	\N	\N	\N
776	202	4	2	2BHK	Available	OCCUPIED	\N	\N	\N
777	203	4	2	2BHK	Owner 81	AVAILABLE_SALE	\N	9500000	+91 9802266734
778	204	4	2	2BHK	Available	OCCUPIED	\N	\N	\N
779	301	4	3	2BHK	Owner 80	OCCUPIED	\N	\N	\N
780	302	4	3	2BHK	Owner 80	OCCUPIED	\N	\N	\N
781	303	4	3	2BHK	Available	OCCUPIED	\N	\N	\N
782	304	4	3	2BHK	Owner 78	OCCUPIED	\N	\N	\N
783	401	4	4	2BHK	Owner 97	OCCUPIED	\N	\N	\N
784	402	4	4	2BHK	Owner 79	AVAILABLE_SALE	\N	9000000	+91 9264099761
785	403	4	4	2BHK	Owner 34	AVAILABLE_RENT	47000	\N	+91 9253226237
786	404	4	4	2BHK	Available	OCCUPIED	\N	\N	\N
787	501	4	5	2BHK	Owner 59	OCCUPIED	\N	\N	\N
788	502	4	5	2BHK	Owner 24	AVAILABLE_RENT	46000	\N	+91 9742802152
789	503	4	5	2BHK	Owner 70	OCCUPIED	\N	\N	\N
790	504	4	5	2BHK	Available	OCCUPIED	\N	\N	\N
791	601	4	6	3BHK	Available	AVAILABLE_RENT	75000	\N	+91 9329473585
792	602	4	6	3BHK	Owner 25	OCCUPIED	\N	\N	\N
793	101	5	1	2BHK	Available	OCCUPIED	\N	\N	\N
794	102	5	1	2BHK	Owner 31	AVAILABLE_SALE	\N	8500000	+91 9500607611
795	103	5	1	2BHK	Owner 3	OCCUPIED	\N	\N	\N
796	104	5	1	2BHK	Available	OCCUPIED	\N	\N	\N
797	201	5	2	2BHK	Owner 38	OCCUPIED	\N	\N	\N
798	202	5	2	2BHK	Available	OCCUPIED	\N	\N	\N
799	203	5	2	2BHK	Owner 48	AVAILABLE_RENT	32000	\N	+91 9184505942
800	204	5	2	2BHK	Available	OCCUPIED	\N	\N	\N
801	301	5	3	2BHK	Available	OCCUPIED	\N	\N	\N
802	302	5	3	2BHK	Available	OCCUPIED	\N	\N	\N
803	303	5	3	2BHK	Owner 65	OCCUPIED	\N	\N	\N
804	304	5	3	2BHK	Owner 71	OCCUPIED	\N	\N	\N
805	401	5	4	2BHK	Owner 22	OCCUPIED	\N	\N	\N
806	402	5	4	2BHK	Owner 32	OCCUPIED	\N	\N	\N
807	403	5	4	2BHK	Owner 29	AVAILABLE_RENT	30000	\N	+91 9535641062
808	404	5	4	2BHK	Available	AVAILABLE_SALE	\N	11600000	+91 9980439951
809	501	5	5	2BHK	Available	OCCUPIED	\N	\N	\N
810	502	5	5	2BHK	Owner 63	AVAILABLE_RENT	32000	\N	+91 9832824910
811	503	5	5	2BHK	Owner 88	OCCUPIED	\N	\N	\N
812	504	5	5	2BHK	Available	OCCUPIED	\N	\N	\N
813	601	5	6	3BHK	Owner 9	OCCUPIED	\N	\N	\N
814	602	5	6	3BHK	Available	AVAILABLE_SALE	\N	17600000	+91 9394286626
815	101	6	1	2BHK	Available	AVAILABLE_SALE	\N	10200000	+91 9651566734
816	102	6	1	2BHK	Available	OCCUPIED	\N	\N	\N
817	103	6	1	2BHK	Owner 16	OCCUPIED	\N	\N	\N
818	104	6	1	2BHK	Owner 18	AVAILABLE_SALE	\N	10900000	+91 9719713916
819	201	6	2	2BHK	Available	OCCUPIED	\N	\N	\N
820	202	6	2	2BHK	Owner 77	AVAILABLE_RENT	39000	\N	+91 9766841733
821	203	6	2	2BHK	Available	OCCUPIED	\N	\N	\N
822	204	6	2	2BHK	Owner 79	OCCUPIED	\N	\N	\N
823	301	6	3	2BHK	Available	AVAILABLE_RENT	32000	\N	+91 9470402002
824	302	6	3	2BHK	Available	AVAILABLE_RENT	49000	\N	+91 9770693996
825	303	6	3	2BHK	Owner 16	OCCUPIED	\N	\N	\N
826	304	6	3	2BHK	Owner 23	AVAILABLE_RENT	47000	\N	+91 9706477714
827	401	6	4	2BHK	Available	AVAILABLE_SALE	\N	8500000	+91 9987481572
828	402	6	4	2BHK	Owner 59	AVAILABLE_SALE	\N	9100000	+91 9902693379
829	403	6	4	2BHK	Owner 90	OCCUPIED	\N	\N	\N
830	404	6	4	2BHK	Available	AVAILABLE_RENT	43000	\N	+91 9677030181
831	501	6	5	2BHK	Available	OCCUPIED	\N	\N	\N
832	502	6	5	2BHK	Owner 95	AVAILABLE_RENT	43000	\N	+91 9833369822
833	503	6	5	2BHK	Owner 92	OCCUPIED	\N	\N	\N
834	504	6	5	2BHK	Available	OCCUPIED	\N	\N	\N
835	601	6	6	3BHK	Owner 34	OCCUPIED	\N	\N	\N
836	602	6	6	3BHK	Available	AVAILABLE_RENT	64000	\N	+91 9485365359
837	101	7	1	2BHK	Owner 62	OCCUPIED	\N	\N	\N
838	102	7	1	2BHK	Available	OCCUPIED	\N	\N	\N
839	103	7	1	2BHK	Owner 3	OCCUPIED	\N	\N	\N
840	104	7	1	2BHK	Owner 28	AVAILABLE_SALE	\N	12200000	+91 9621169440
841	201	7	2	2BHK	Owner 32	OCCUPIED	\N	\N	\N
842	202	7	2	2BHK	Owner 79	AVAILABLE_RENT	40000	\N	+91 9495759833
843	203	7	2	2BHK	Owner 66	OCCUPIED	\N	\N	\N
844	204	7	2	2BHK	Available	OCCUPIED	\N	\N	\N
845	301	7	3	2BHK	Owner 69	AVAILABLE_RENT	40000	\N	+91 9950258405
846	302	7	3	2BHK	Owner 55	AVAILABLE_SALE	\N	8900000	+91 9761923397
847	303	7	3	2BHK	Owner 28	AVAILABLE_RENT	42000	\N	+91 9672878073
848	304	7	3	2BHK	Owner 48	OCCUPIED	\N	\N	\N
849	401	7	4	2BHK	Owner 41	OCCUPIED	\N	\N	\N
850	402	7	4	2BHK	Available	OCCUPIED	\N	\N	\N
851	403	7	4	2BHK	Owner 49	OCCUPIED	\N	\N	\N
852	404	7	4	2BHK	Owner 16	OCCUPIED	\N	\N	\N
853	501	7	5	2BHK	Available	AVAILABLE_RENT	31000	\N	+91 9346270278
854	502	7	5	2BHK	Owner 90	OCCUPIED	\N	\N	\N
855	503	7	5	2BHK	Owner 99	AVAILABLE_SALE	\N	11500000	+91 9836199689
856	504	7	5	2BHK	Owner 55	AVAILABLE_SALE	\N	10600000	+91 9752792409
857	601	7	6	3BHK	Owner 27	AVAILABLE_SALE	\N	16800000	+91 9782125130
858	602	7	6	3BHK	Owner 37	OCCUPIED	\N	\N	\N
859	101	8	1	2BHK	Owner 80	AVAILABLE_SALE	\N	11400000	+91 9989718274
860	102	8	1	2BHK	Owner 63	OCCUPIED	\N	\N	\N
861	103	8	1	2BHK	Owner 89	OCCUPIED	\N	\N	\N
862	104	8	1	2BHK	Owner 56	OCCUPIED	\N	\N	\N
863	201	8	2	2BHK	Owner 60	OCCUPIED	\N	\N	\N
864	202	8	2	2BHK	Owner 81	OCCUPIED	\N	\N	\N
865	203	8	2	2BHK	Owner 73	OCCUPIED	\N	\N	\N
866	204	8	2	2BHK	Owner 41	OCCUPIED	\N	\N	\N
867	301	8	3	2BHK	Owner 15	OCCUPIED	\N	\N	\N
868	302	8	3	2BHK	Owner 96	OCCUPIED	\N	\N	\N
869	303	8	3	2BHK	Owner 54	OCCUPIED	\N	\N	\N
870	304	8	3	2BHK	Owner 25	OCCUPIED	\N	\N	\N
871	401	8	4	2BHK	Owner 24	OCCUPIED	\N	\N	\N
872	402	8	4	2BHK	Available	OCCUPIED	\N	\N	\N
873	403	8	4	2BHK	Available	OCCUPIED	\N	\N	\N
874	404	8	4	2BHK	Available	OCCUPIED	\N	\N	\N
875	501	8	5	2BHK	Owner 12	OCCUPIED	\N	\N	\N
876	502	8	5	2BHK	Owner 92	OCCUPIED	\N	\N	\N
877	503	8	5	2BHK	Owner 22	AVAILABLE_RENT	32000	\N	+91 9891238864
878	504	8	5	2BHK	Owner 37	OCCUPIED	\N	\N	\N
879	601	8	6	3BHK	Owner 89	OCCUPIED	\N	\N	\N
880	602	8	6	3BHK	Owner 61	AVAILABLE_RENT	64000	\N	+91 9734342007
881	101	9	1	2BHK	Owner 75	AVAILABLE_SALE	\N	8100000	+91 9297101563
882	102	9	1	2BHK	Owner 61	OCCUPIED	\N	\N	\N
883	103	9	1	2BHK	Owner 80	OCCUPIED	\N	\N	\N
884	104	9	1	2BHK	Owner 18	OCCUPIED	\N	\N	\N
885	201	9	2	2BHK	Owner 63	OCCUPIED	\N	\N	\N
886	202	9	2	2BHK	Available	OCCUPIED	\N	\N	\N
887	203	9	2	2BHK	Available	AVAILABLE_RENT	36000	\N	+91 9886268160
888	204	9	2	2BHK	Owner 52	OCCUPIED	\N	\N	\N
889	301	9	3	2BHK	Available	OCCUPIED	\N	\N	\N
890	302	9	3	2BHK	Owner 54	AVAILABLE_RENT	40000	\N	+91 9726350895
891	303	9	3	2BHK	Owner 63	OCCUPIED	\N	\N	\N
892	304	9	3	2BHK	Available	OCCUPIED	\N	\N	\N
893	401	9	4	2BHK	Owner 91	OCCUPIED	\N	\N	\N
894	402	9	4	2BHK	Owner 41	OCCUPIED	\N	\N	\N
895	403	9	4	2BHK	Available	OCCUPIED	\N	\N	\N
896	404	9	4	2BHK	Owner 76	OCCUPIED	\N	\N	\N
897	501	9	5	2BHK	Owner 14	AVAILABLE_RENT	41000	\N	+91 9226916960
898	502	9	5	2BHK	Owner 7	OCCUPIED	\N	\N	\N
899	503	9	5	2BHK	Owner 36	OCCUPIED	\N	\N	\N
900	504	9	5	2BHK	Available	OCCUPIED	\N	\N	\N
901	601	9	6	3BHK	Available	OCCUPIED	\N	\N	\N
902	602	9	6	3BHK	Owner 63	AVAILABLE_RENT	67000	\N	+91 9091481814
903	101	10	1	2BHK	Owner 99	OCCUPIED	\N	\N	\N
904	102	10	1	2BHK	Owner 34	OCCUPIED	\N	\N	\N
905	103	10	1	2BHK	Owner 32	OCCUPIED	\N	\N	\N
906	104	10	1	2BHK	Owner 61	OCCUPIED	\N	\N	\N
907	201	10	2	2BHK	Available	OCCUPIED	\N	\N	\N
908	202	10	2	2BHK	Available	OCCUPIED	\N	\N	\N
909	203	10	2	2BHK	Owner 88	OCCUPIED	\N	\N	\N
910	204	10	2	2BHK	Owner 63	OCCUPIED	\N	\N	\N
911	301	10	3	2BHK	Owner 21	OCCUPIED	\N	\N	\N
912	302	10	3	2BHK	Available	AVAILABLE_RENT	36000	\N	+91 9823303487
913	303	10	3	2BHK	Owner 25	OCCUPIED	\N	\N	\N
914	304	10	3	2BHK	Available	OCCUPIED	\N	\N	\N
915	401	10	4	2BHK	Owner 10	OCCUPIED	\N	\N	\N
916	402	10	4	2BHK	Owner 0	OCCUPIED	\N	\N	\N
917	403	10	4	2BHK	Owner 28	OCCUPIED	\N	\N	\N
918	404	10	4	2BHK	Available	OCCUPIED	\N	\N	\N
919	501	10	5	2BHK	Available	AVAILABLE_RENT	44000	\N	+91 9144835645
920	502	10	5	2BHK	Owner 70	AVAILABLE_RENT	43000	\N	+91 9772098095
921	503	10	5	2BHK	Available	OCCUPIED	\N	\N	\N
922	504	10	5	2BHK	Available	OCCUPIED	\N	\N	\N
923	601	10	6	3BHK	Owner 17	OCCUPIED	\N	\N	\N
924	602	10	6	3BHK	Available	OCCUPIED	\N	\N	\N
925	101	11	1	2BHK	Available	OCCUPIED	\N	\N	\N
926	102	11	1	2BHK	Available	OCCUPIED	\N	\N	\N
927	103	11	1	2BHK	Owner 60	OCCUPIED	\N	\N	\N
928	104	11	1	2BHK	Owner 12	OCCUPIED	\N	\N	\N
929	201	11	2	2BHK	Owner 2	AVAILABLE_SALE	\N	11400000	+91 9601641468
930	202	11	2	2BHK	Owner 44	OCCUPIED	\N	\N	\N
931	203	11	2	2BHK	Available	OCCUPIED	\N	\N	\N
932	204	11	2	2BHK	Owner 3	AVAILABLE_RENT	35000	\N	+91 9342852997
933	301	11	3	2BHK	Available	OCCUPIED	\N	\N	\N
934	302	11	3	2BHK	Available	OCCUPIED	\N	\N	\N
935	303	11	3	2BHK	Owner 98	OCCUPIED	\N	\N	\N
936	304	11	3	2BHK	Owner 93	OCCUPIED	\N	\N	\N
937	401	11	4	2BHK	Owner 57	OCCUPIED	\N	\N	\N
938	402	11	4	2BHK	Available	OCCUPIED	\N	\N	\N
939	403	11	4	2BHK	Owner 86	AVAILABLE_RENT	44000	\N	+91 9719380961
940	404	11	4	2BHK	Owner 56	OCCUPIED	\N	\N	\N
941	501	11	5	2BHK	Owner 31	OCCUPIED	\N	\N	\N
942	502	11	5	2BHK	Owner 86	OCCUPIED	\N	\N	\N
943	503	11	5	2BHK	Available	OCCUPIED	\N	\N	\N
944	504	11	5	2BHK	Owner 4	AVAILABLE_RENT	46000	\N	+91 9611027038
945	601	11	6	3BHK	Available	AVAILABLE_SALE	\N	16800000	+91 9433959711
946	602	11	6	3BHK	Available	AVAILABLE_RENT	76000	\N	+91 9586442606
947	101	12	1	2BHK	Available	OCCUPIED	\N	\N	\N
948	102	12	1	2BHK	Available	OCCUPIED	\N	\N	\N
949	103	12	1	2BHK	Owner 43	AVAILABLE_RENT	40000	\N	+91 9411586617
950	104	12	1	2BHK	Owner 25	OCCUPIED	\N	\N	\N
951	201	12	2	2BHK	Available	OCCUPIED	\N	\N	\N
952	202	12	2	2BHK	Owner 34	AVAILABLE_SALE	\N	8300000	+91 9359270275
953	203	12	2	2BHK	Owner 59	OCCUPIED	\N	\N	\N
954	204	12	2	2BHK	Available	AVAILABLE_RENT	46000	\N	+91 9783103156
955	301	12	3	2BHK	Available	OCCUPIED	\N	\N	\N
956	302	12	3	2BHK	Owner 83	OCCUPIED	\N	\N	\N
957	303	12	3	2BHK	Owner 47	OCCUPIED	\N	\N	\N
958	304	12	3	2BHK	Owner 24	OCCUPIED	\N	\N	\N
959	401	12	4	2BHK	Owner 13	OCCUPIED	\N	\N	\N
960	402	12	4	2BHK	Owner 50	OCCUPIED	\N	\N	\N
961	403	12	4	2BHK	Owner 7	OCCUPIED	\N	\N	\N
962	404	12	4	2BHK	Owner 72	AVAILABLE_SALE	\N	11300000	+91 9288954801
963	501	12	5	2BHK	Owner 15	OCCUPIED	\N	\N	\N
964	502	12	5	2BHK	Available	OCCUPIED	\N	\N	\N
965	503	12	5	2BHK	Owner 25	OCCUPIED	\N	\N	\N
966	504	12	5	2BHK	Available	OCCUPIED	\N	\N	\N
967	601	12	6	3BHK	Available	OCCUPIED	\N	\N	\N
968	602	12	6	3BHK	Owner 89	OCCUPIED	\N	\N	\N
969	101	13	1	2BHK	Owner 36	AVAILABLE_SALE	\N	12600000	+91 9201452925
970	102	13	1	2BHK	Available	AVAILABLE_SALE	\N	12700000	+91 9783867935
971	103	13	1	2BHK	Owner 53	OCCUPIED	\N	\N	\N
972	104	13	1	2BHK	Available	OCCUPIED	\N	\N	\N
973	201	13	2	2BHK	Owner 81	OCCUPIED	\N	\N	\N
974	202	13	2	2BHK	Owner 45	OCCUPIED	\N	\N	\N
975	203	13	2	2BHK	Available	AVAILABLE_SALE	\N	8600000	+91 9225348319
976	204	13	2	2BHK	Available	OCCUPIED	\N	\N	\N
977	301	13	3	2BHK	Owner 48	OCCUPIED	\N	\N	\N
978	302	13	3	2BHK	Available	AVAILABLE_RENT	35000	\N	+91 9592531547
979	303	13	3	2BHK	Owner 68	OCCUPIED	\N	\N	\N
980	304	13	3	2BHK	Available	OCCUPIED	\N	\N	\N
981	401	13	4	2BHK	Owner 22	OCCUPIED	\N	\N	\N
982	402	13	4	2BHK	Owner 97	AVAILABLE_SALE	\N	9400000	+91 9810025968
983	403	13	4	2BHK	Owner 16	AVAILABLE_SALE	\N	12700000	+91 9085595357
984	404	13	4	2BHK	Owner 85	AVAILABLE_RENT	49000	\N	+91 9510906685
985	501	13	5	2BHK	Owner 51	OCCUPIED	\N	\N	\N
986	502	13	5	2BHK	Owner 11	OCCUPIED	\N	\N	\N
987	503	13	5	2BHK	Owner 0	OCCUPIED	\N	\N	\N
988	504	13	5	2BHK	Owner 4	AVAILABLE_SALE	\N	11600000	+91 9332492120
989	601	13	6	3BHK	Available	OCCUPIED	\N	\N	\N
990	602	13	6	3BHK	Owner 29	OCCUPIED	\N	\N	\N
991	101	14	1	2BHK	Owner 68	OCCUPIED	\N	\N	\N
992	102	14	1	2BHK	Owner 61	OCCUPIED	\N	\N	\N
993	103	14	1	2BHK	Owner 33	OCCUPIED	\N	\N	\N
994	104	14	1	2BHK	Owner 23	OCCUPIED	\N	\N	\N
995	201	14	2	2BHK	Owner 61	AVAILABLE_RENT	47000	\N	+91 9310418704
996	202	14	2	2BHK	Available	AVAILABLE_SALE	\N	10300000	+91 9238146156
997	203	14	2	2BHK	Owner 25	OCCUPIED	\N	\N	\N
998	204	14	2	2BHK	Owner 83	OCCUPIED	\N	\N	\N
999	301	14	3	2BHK	Available	AVAILABLE_SALE	\N	9300000	+91 9651599738
1000	302	14	3	2BHK	Owner 22	OCCUPIED	\N	\N	\N
1001	303	14	3	2BHK	Owner 81	AVAILABLE_SALE	\N	8600000	+91 9829783113
1002	304	14	3	2BHK	Owner 62	AVAILABLE_SALE	\N	11400000	+91 9004933830
1003	401	14	4	2BHK	Owner 94	OCCUPIED	\N	\N	\N
1004	402	14	4	2BHK	Available	AVAILABLE_SALE	\N	10600000	+91 9331056290
1005	403	14	4	2BHK	Owner 7	OCCUPIED	\N	\N	\N
1006	404	14	4	2BHK	Owner 25	OCCUPIED	\N	\N	\N
1007	501	14	5	2BHK	Available	AVAILABLE_RENT	44000	\N	+91 9721748177
1008	502	14	5	2BHK	Available	AVAILABLE_SALE	\N	10800000	+91 9272905487
1009	503	14	5	2BHK	Owner 32	AVAILABLE_SALE	\N	8600000	+91 9387537861
1010	504	14	5	2BHK	Owner 42	AVAILABLE_SALE	\N	8000000	+91 9429243497
1011	601	14	6	3BHK	Owner 59	OCCUPIED	\N	\N	\N
1012	602	14	6	3BHK	Available	OCCUPIED	\N	\N	\N
1013	101	15	1	2BHK	Owner 15	OCCUPIED	\N	\N	\N
1014	102	15	1	2BHK	Owner 74	OCCUPIED	\N	\N	\N
1015	103	15	1	2BHK	Available	OCCUPIED	\N	\N	\N
1016	104	15	1	2BHK	Owner 21	AVAILABLE_RENT	49000	\N	+91 9859453694
1017	201	15	2	2BHK	Owner 73	AVAILABLE_SALE	\N	9500000	+91 9538042037
1018	202	15	2	2BHK	Owner 89	OCCUPIED	\N	\N	\N
1019	203	15	2	2BHK	Available	OCCUPIED	\N	\N	\N
1020	204	15	2	2BHK	Available	OCCUPIED	\N	\N	\N
1021	301	15	3	2BHK	Owner 18	OCCUPIED	\N	\N	\N
1022	302	15	3	2BHK	Owner 10	OCCUPIED	\N	\N	\N
1023	303	15	3	2BHK	Owner 77	OCCUPIED	\N	\N	\N
1024	304	15	3	2BHK	Owner 32	AVAILABLE_RENT	35000	\N	+91 9004124049
1025	401	15	4	2BHK	Owner 23	AVAILABLE_SALE	\N	12400000	+91 9659856311
1026	402	15	4	2BHK	Owner 4	OCCUPIED	\N	\N	\N
1027	403	15	4	2BHK	Owner 98	OCCUPIED	\N	\N	\N
1028	404	15	4	2BHK	Owner 75	AVAILABLE_RENT	39000	\N	+91 9369036952
1029	501	15	5	2BHK	Owner 75	AVAILABLE_RENT	45000	\N	+91 9154933731
1030	502	15	5	2BHK	Owner 53	OCCUPIED	\N	\N	\N
1031	503	15	5	2BHK	Owner 93	AVAILABLE_RENT	35000	\N	+91 9251693901
1032	504	15	5	2BHK	Owner 96	OCCUPIED	\N	\N	\N
1033	601	15	6	3BHK	Owner 81	OCCUPIED	\N	\N	\N
1034	602	15	6	3BHK	Owner 38	OCCUPIED	\N	\N	\N
1035	101	16	1	2BHK	Owner 54	OCCUPIED	\N	\N	\N
1036	102	16	1	2BHK	Available	AVAILABLE_SALE	\N	11200000	+91 9744139210
1037	103	16	1	2BHK	Owner 86	OCCUPIED	\N	\N	\N
1038	104	16	1	2BHK	Owner 37	OCCUPIED	\N	\N	\N
1039	201	16	2	2BHK	Owner 49	OCCUPIED	\N	\N	\N
1040	202	16	2	2BHK	Available	OCCUPIED	\N	\N	\N
1041	203	16	2	2BHK	Available	OCCUPIED	\N	\N	\N
1042	204	16	2	2BHK	Owner 92	OCCUPIED	\N	\N	\N
1043	301	16	3	2BHK	Owner 40	OCCUPIED	\N	\N	\N
1044	302	16	3	2BHK	Owner 26	OCCUPIED	\N	\N	\N
1045	303	16	3	2BHK	Owner 77	OCCUPIED	\N	\N	\N
1046	304	16	3	2BHK	Available	OCCUPIED	\N	\N	\N
1047	401	16	4	2BHK	Owner 37	AVAILABLE_RENT	47000	\N	+91 9225463734
1048	402	16	4	2BHK	Owner 86	AVAILABLE_RENT	37000	\N	+91 9025132351
1049	403	16	4	2BHK	Owner 79	OCCUPIED	\N	\N	\N
1050	404	16	4	2BHK	Owner 66	OCCUPIED	\N	\N	\N
1051	501	16	5	2BHK	Owner 17	OCCUPIED	\N	\N	\N
1052	502	16	5	2BHK	Owner 80	AVAILABLE_RENT	48000	\N	+91 9073796456
1053	503	16	5	2BHK	Owner 98	AVAILABLE_RENT	40000	\N	+91 9228395314
1054	504	16	5	2BHK	Available	OCCUPIED	\N	\N	\N
1055	601	16	6	3BHK	Available	OCCUPIED	\N	\N	\N
1056	602	16	6	3BHK	Available	OCCUPIED	\N	\N	\N
\.


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.bookings (id, user_id, amenity_id, start_time, end_time, status) FROM stdin;
\.


--
-- Data for Name: session; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.session (sid, sess, expire) FROM stdin;
1mmureoHRmvpzomRE2pL8TUz06a6y8jo	{"cookie":{"originalMaxAge":null,"expires":null,"httpOnly":true,"path":"/"}}	2025-03-13 19:20:08
CRW9L7ls3Bfu__vQHMnZMHmBbM4lvF_3	{"cookie":{"originalMaxAge":null,"expires":null,"httpOnly":true,"path":"/"},"passport":{"user":1}}	2025-03-13 19:35:11
\.


--
-- Data for Name: towers; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.towers (id, name) FROM stdin;
1	Tower 1
2	Tower 2
3	Tower 3
4	Tower 4
5	Tower 5
6	Tower 6
7	Tower 7
8	Tower 8
9	Tower 9
10	Tower 10
11	Tower 11
12	Tower 12
13	Tower 13
14	Tower 14
15	Tower 15
16	Tower 16
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

COPY public.users (id, username, password, is_admin, name, apartment_id) FROM stdin;
1	aditya	ca400bcbf331d272e520b29d0bdd8c94d53c99af0c36b3395ddc8e3f5f198386152de707dc61396c54a7840d8fde56f4d0b7b03015ce979e84b85e38656d18e9.b88224583fcfa92acb70bb09930a101f	f	Aditya	\N
2	aryan	a7833518bb814f59114e81dc2a6c4ab92c765b690a040b6fb8dc993bffdac487c9875db800548f9923fa5b5223624a05b75b6308051f96d8b380571d53fe2972.fdc6f319de07bcee87dcff7d14a541c3	f	aryan	\N
\.


--
-- Name: amenities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.amenities_id_seq', 6, true);


--
-- Name: apartments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.apartments_id_seq', 1056, true);


--
-- Name: bookings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.bookings_id_seq', 1, false);


--
-- Name: towers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.towers_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- Name: amenities amenities_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.amenities
    ADD CONSTRAINT amenities_pkey PRIMARY KEY (id);


--
-- Name: apartments apartments_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.apartments
    ADD CONSTRAINT apartments_pkey PRIMARY KEY (id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (sid);


--
-- Name: towers towers_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.towers
    ADD CONSTRAINT towers_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: IDX_session_expire; Type: INDEX; Schema: public; Owner: neondb_owner
--

CREATE INDEX "IDX_session_expire" ON public.session USING btree (expire);


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO neon_superuser WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON TABLES TO neon_superuser WITH GRANT OPTION;


--
-- PostgreSQL database dump complete
--

