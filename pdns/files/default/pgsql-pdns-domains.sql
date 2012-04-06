--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: domains; Type: TABLE; Schema: public; Owner: pdns; Tablespace: 
--

CREATE TABLE domains (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    master character varying(128) DEFAULT NULL::character varying,
    last_check integer,
    type character varying(6) NOT NULL,
    notified_serial integer,
    account character varying(40) DEFAULT NULL::character varying
);


ALTER TABLE public.domains OWNER TO pdns;

--
-- Name: domains_id_seq; Type: SEQUENCE; Schema: public; Owner: pdns
--

CREATE SEQUENCE domains_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.domains_id_seq OWNER TO pdns;

--
-- Name: domains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pdns
--

ALTER SEQUENCE domains_id_seq OWNED BY domains.id;


--
-- Name: domains_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pdns
--

SELECT pg_catalog.setval('domains_id_seq', 4, true);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: pdns
--

ALTER TABLE ONLY domains ALTER COLUMN id SET DEFAULT nextval('domains_id_seq'::regclass);


--
-- Data for Name: domains; Type: TABLE DATA; Schema: public; Owner: pdns
--

COPY domains (id, name, master, last_check, type, notified_serial, account) FROM stdin;
\.


--
-- Name: domains_pkey; Type: CONSTRAINT; Schema: public; Owner: pdns; Tablespace: 
--

ALTER TABLE ONLY domains
    ADD CONSTRAINT domains_pkey PRIMARY KEY (id);


--
-- Name: name_index; Type: INDEX; Schema: public; Owner: pdns; Tablespace: 
--

CREATE UNIQUE INDEX name_index ON domains USING btree (name);


--
-- PostgreSQL database dump complete
--

