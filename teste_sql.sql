--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

-- Started on 2024-07-08 16:56:07

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

--
-- TOC entry 219 (class 1255 OID 16428)
-- Name: registrar_log(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.registrar_log() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO log_operacoes (tipo_operacao, registro_id) VALUES ('Insert', NEW.id);
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO log_operacoes (tipo_operacao, registro_id) VALUES ('Update', NEW.id);
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO log_operacoes (tipo_operacao, registro_id) VALUES ('Delete', OLD.id);
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.registrar_log() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 16434)
-- Name: cadastro; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cadastro (
    id integer NOT NULL,
    campo_texto character varying(255) NOT NULL,
    campo_numerico integer NOT NULL,
    CONSTRAINT cadastro_campo_numerico_check CHECK ((campo_numerico > 0)),
    CONSTRAINT cadastro_campo_texto_check CHECK ((char_length((campo_texto)::text) > 0))
);


ALTER TABLE public.cadastro OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16433)
-- Name: cadastro_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cadastro_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cadastro_id_seq OWNER TO postgres;

--
-- TOC entry 4805 (class 0 OID 0)
-- Dependencies: 215
-- Name: cadastro_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cadastro_id_seq OWNED BY public.cadastro.id;


--
-- TOC entry 218 (class 1259 OID 16445)
-- Name: log_operacoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_operacoes (
    id integer NOT NULL,
    data_hora timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    tipo_operacao character varying(10) NOT NULL,
    registro_id integer
);


ALTER TABLE public.log_operacoes OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16444)
-- Name: log_operacoes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.log_operacoes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.log_operacoes_id_seq OWNER TO postgres;

--
-- TOC entry 4806 (class 0 OID 0)
-- Dependencies: 217
-- Name: log_operacoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.log_operacoes_id_seq OWNED BY public.log_operacoes.id;


--
-- TOC entry 4640 (class 2604 OID 16437)
-- Name: cadastro id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cadastro ALTER COLUMN id SET DEFAULT nextval('public.cadastro_id_seq'::regclass);


--
-- TOC entry 4641 (class 2604 OID 16448)
-- Name: log_operacoes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_operacoes ALTER COLUMN id SET DEFAULT nextval('public.log_operacoes_id_seq'::regclass);


--
-- TOC entry 4797 (class 0 OID 16434)
-- Dependencies: 216
-- Data for Name: cadastro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cadastro (id, campo_texto, campo_numerico) FROM stdin;
2	luan	2
4	luan	234
7	luan	2222
\.


--
-- TOC entry 4799 (class 0 OID 16445)
-- Dependencies: 218
-- Data for Name: log_operacoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_operacoes (id, data_hora, tipo_operacao, registro_id) FROM stdin;
1	2024-07-08 16:38:02.538862	Insert	2
2	2024-07-08 16:38:21.316843	Insert	4
3	2024-07-08 16:40:43.741402	Insert	7
\.


--
-- TOC entry 4807 (class 0 OID 0)
-- Dependencies: 215
-- Name: cadastro_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cadastro_id_seq', 8, true);


--
-- TOC entry 4808 (class 0 OID 0)
-- Dependencies: 217
-- Name: log_operacoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.log_operacoes_id_seq', 3, true);


--
-- TOC entry 4646 (class 2606 OID 16443)
-- Name: cadastro cadastro_campo_numerico_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cadastro
    ADD CONSTRAINT cadastro_campo_numerico_key UNIQUE (campo_numerico);


--
-- TOC entry 4648 (class 2606 OID 16441)
-- Name: cadastro cadastro_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cadastro
    ADD CONSTRAINT cadastro_pkey PRIMARY KEY (id);


--
-- TOC entry 4650 (class 2606 OID 16451)
-- Name: log_operacoes log_operacoes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_operacoes
    ADD CONSTRAINT log_operacoes_pkey PRIMARY KEY (id);


--
-- TOC entry 4652 (class 2620 OID 16457)
-- Name: cadastro trigger_log_operacoes; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_log_operacoes AFTER INSERT OR DELETE OR UPDATE ON public.cadastro FOR EACH ROW EXECUTE FUNCTION public.registrar_log();


--
-- TOC entry 4651 (class 2606 OID 16452)
-- Name: log_operacoes log_operacoes_registro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_operacoes
    ADD CONSTRAINT log_operacoes_registro_id_fkey FOREIGN KEY (registro_id) REFERENCES public.cadastro(id);


-- Completed on 2024-07-08 16:56:07

--
-- PostgreSQL database dump complete
--

