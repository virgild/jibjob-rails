--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: resumes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE resumes (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    name character varying NOT NULL,
    content text NOT NULL,
    guid character varying NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    pdf_file_name character varying,
    pdf_content_type character varying,
    pdf_file_size integer,
    pdf_updated_at timestamp without time zone,
    edition integer DEFAULT 1
);


--
-- Name: resumes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE resumes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resumes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE resumes_id_seq OWNED BY resumes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: signup_confirmations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE signup_confirmations (
    user_id bigint NOT NULL,
    token character varying NOT NULL,
    confirmed_at timestamp without time zone
);


--
-- Name: signups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE signups (
    user_id bigint NOT NULL,
    ip_address inet,
    user_agent character varying,
    extras json,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id bigint NOT NULL,
    username character varying NOT NULL,
    email character varying NOT NULL,
    password_digest character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    default_role character varying,
    timezone character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY resumes ALTER COLUMN id SET DEFAULT nextval('resumes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: resumes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resumes
    ADD CONSTRAINT resumes_pkey PRIMARY KEY (id);


--
-- Name: signup_confirmations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY signup_confirmations
    ADD CONSTRAINT signup_confirmations_pkey PRIMARY KEY (user_id);


--
-- Name: signups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY signups
    ADD CONSTRAINT signups_pkey PRIMARY KEY (user_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20150121185400');

INSERT INTO schema_migrations (version) VALUES ('20150122004049');

INSERT INTO schema_migrations (version) VALUES ('20150122142945');

INSERT INTO schema_migrations (version) VALUES ('20150124170752');

INSERT INTO schema_migrations (version) VALUES ('20150124225405');

INSERT INTO schema_migrations (version) VALUES ('20150125010553');

INSERT INTO schema_migrations (version) VALUES ('20150125042850');

INSERT INTO schema_migrations (version) VALUES ('20150125224433');

INSERT INTO schema_migrations (version) VALUES ('20150129191035');

