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
-- Name: password_recoveries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE password_recoveries (
    id bigint NOT NULL,
    user_id bigint,
    token character varying NOT NULL,
    created_at timestamp without time zone
);


--
-- Name: password_recoveries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE password_recoveries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: password_recoveries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE password_recoveries_id_seq OWNED BY password_recoveries.id;


--
-- Name: publication_views; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE publication_views (
    id bigint NOT NULL,
    resume_id bigint NOT NULL,
    ip_addr inet NOT NULL,
    url character varying NOT NULL,
    referrer character varying,
    user_agent character varying,
    created_at timestamp without time zone NOT NULL,
    lat numeric(9,6),
    lng numeric(9,6),
    city character varying,
    state character varying,
    country character varying
);


--
-- Name: publication_views_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE publication_views_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publication_views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE publication_views_id_seq OWNED BY publication_views.id;


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
    edition integer DEFAULT 0 NOT NULL,
    slug character varying NOT NULL,
    is_published boolean DEFAULT false NOT NULL,
    access_code character varying,
    pdf_edition integer DEFAULT 0 NOT NULL
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
    id bigint NOT NULL,
    user_id bigint,
    token character varying NOT NULL,
    confirmed_at timestamp without time zone
);


--
-- Name: signup_confirmations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE signup_confirmations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: signup_confirmations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE signup_confirmations_id_seq OWNED BY signup_confirmations.id;


--
-- Name: signups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE signups (
    id bigint NOT NULL,
    user_id bigint,
    ip_address inet,
    user_agent character varying,
    extras json,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: signups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE signups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: signups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE signups_id_seq OWNED BY signups.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id bigint NOT NULL,
    username character varying NOT NULL,
    email character varying,
    password_digest character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    timezone character varying,
    default_role character varying,
    auth_provider character varying,
    auth_uid character varying,
    auth_name character varying,
    auth_token character varying,
    auth_secret character varying,
    auth_expires timestamp without time zone
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

ALTER TABLE ONLY password_recoveries ALTER COLUMN id SET DEFAULT nextval('password_recoveries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY publication_views ALTER COLUMN id SET DEFAULT nextval('publication_views_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY resumes ALTER COLUMN id SET DEFAULT nextval('resumes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY signup_confirmations ALTER COLUMN id SET DEFAULT nextval('signup_confirmations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY signups ALTER COLUMN id SET DEFAULT nextval('signups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: password_recoveries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY password_recoveries
    ADD CONSTRAINT password_recoveries_pkey PRIMARY KEY (id);


--
-- Name: publication_views_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY publication_views
    ADD CONSTRAINT publication_views_pkey PRIMARY KEY (id);


--
-- Name: resumes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resumes
    ADD CONSTRAINT resumes_pkey PRIMARY KEY (id);


--
-- Name: signup_confirmations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY signup_confirmations
    ADD CONSTRAINT signup_confirmations_pkey PRIMARY KEY (id);


--
-- Name: signups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY signups
    ADD CONSTRAINT signups_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_publication_views_on_resume_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_publication_views_on_resume_id ON publication_views USING btree (resume_id);


--
-- Name: index_resumes_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_resumes_on_slug ON resumes USING btree (slug);


--
-- Name: index_users_on_auth_provider; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_auth_provider ON users USING btree (auth_provider);


--
-- Name: index_users_on_auth_provider_and_auth_uid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_auth_provider_and_auth_uid ON users USING btree (auth_provider, auth_uid);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_username ON users USING btree (username);


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

INSERT INTO schema_migrations (version) VALUES ('20150130172627');

INSERT INTO schema_migrations (version) VALUES ('20150212022309');

INSERT INTO schema_migrations (version) VALUES ('20150214164426');

INSERT INTO schema_migrations (version) VALUES ('20150216222945');

INSERT INTO schema_migrations (version) VALUES ('20150217003722');

INSERT INTO schema_migrations (version) VALUES ('20150218182355');

INSERT INTO schema_migrations (version) VALUES ('20150221024933');

INSERT INTO schema_migrations (version) VALUES ('20150224030817');

INSERT INTO schema_migrations (version) VALUES ('20150305183547');

INSERT INTO schema_migrations (version) VALUES ('20150305231357');

INSERT INTO schema_migrations (version) VALUES ('20150313044136');

INSERT INTO schema_migrations (version) VALUES ('20150313184743');

INSERT INTO schema_migrations (version) VALUES ('20150313210233');

INSERT INTO schema_migrations (version) VALUES ('20150313213446');

