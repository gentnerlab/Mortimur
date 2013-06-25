--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- Name: breakpoint; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE breakpoint AS (
	func oid,
	linenumber integer,
	targetname text
);


ALTER TYPE public.breakpoint OWNER TO postgres;

--
-- Name: frame; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE frame AS (
	level integer,
	targetname text,
	func oid,
	linenumber integer,
	args text
);


ALTER TYPE public.frame OWNER TO postgres;

--
-- Name: gtsq; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN gtsq AS text;


ALTER DOMAIN public.gtsq OWNER TO postgres;

--
-- Name: gtsvector; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN gtsvector AS pg_catalog.gtsvector;


ALTER DOMAIN public.gtsvector OWNER TO postgres;

--
-- Name: proxyinfo; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE proxyinfo AS (
	serverversionstr text,
	serverversionnum integer,
	proxyapiver integer,
	serverprocessid integer
);


ALTER TYPE public.proxyinfo OWNER TO postgres;

--
-- Name: statinfo; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE statinfo AS (
	word text,
	ndoc integer,
	nentry integer
);


ALTER TYPE public.statinfo OWNER TO postgres;

--
-- Name: targetinfo; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE targetinfo AS (
	target oid,
	schema oid,
	nargs integer,
	argtypes oidvector,
	targetname name,
	argmodes "char"[],
	argnames text[],
	targetlang oid,
	fqname text,
	returnsset boolean,
	returntype oid
);


ALTER TYPE public.targetinfo OWNER TO postgres;

--
-- Name: tokenout; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE tokenout AS (
	tokid integer,
	token text
);


ALTER TYPE public.tokenout OWNER TO postgres;

--
-- Name: tokentype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE tokentype AS (
	tokid integer,
	alias text,
	descr text
);


ALTER TYPE public.tokentype OWNER TO postgres;

--
-- Name: tsdebug; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE tsdebug AS (
	ts_name text,
	tok_type text,
	description text,
	token text,
	dict_name text[],
	tsvector pg_catalog.tsvector
);


ALTER TYPE public.tsdebug OWNER TO postgres;

--
-- Name: tsquery; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN tsquery AS pg_catalog.tsquery;


ALTER DOMAIN public.tsquery OWNER TO postgres;

--
-- Name: tsvector; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN tsvector AS pg_catalog.tsvector;


ALTER DOMAIN public.tsvector OWNER TO postgres;

--
-- Name: var; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE var AS (
	name text,
	varclass character(1),
	linenumber integer,
	isunique boolean,
	isconst boolean,
	isnotnull boolean,
	dtype oid,
	value text
);


ALTER TYPE public.var OWNER TO postgres;

--
-- Name: _get_parser_from_curcfg(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION _get_parser_from_curcfg() RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$select prsname::text from pg_catalog.pg_ts_parser p join pg_ts_config c on cfgparser = p.oid where c.oid = show_curcfg();$$;


ALTER FUNCTION public._get_parser_from_curcfg() OWNER TO postgres;

--
-- Name: add_behavioralconsequence(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_behavioralconsequence(behavioralconsequencename character varying) RETURNS integer
    LANGUAGE sql
    AS $_$
	INSERT INTO behavioralconsequence (behavioralconsequenceid, behavioralconsequencename)
		VALUES((select MAX(behavioralconsequenceid) +1 FROM behavioralconsequence), $1);
	SELECT MAX(behavioralconsequenceid) from behavioralconsequence;
	$_$;


ALTER FUNCTION public.add_behavioralconsequence(behavioralconsequencename character varying) OWNER TO postgres;

--
-- Name: add_cell(character varying, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_cell(cellname character varying, regionid integer, siteid integer, sortmarkercode character varying) RETURNS integer
    LANGUAGE sql
    AS $_$
	INSERT INTO cell (cellid, cellname, regionid, siteid, sortmarkercode)
		VALUES((select MAX(cellid) +1 FROM cell), $1, $2, $3, $4);
	SELECT MAX(cellid) from cell;
	$_$;


ALTER FUNCTION public.add_cell(cellname character varying, regionid integer, siteid integer, sortmarkercode character varying) OWNER TO postgres;

--
-- Name: add_epoch(timestamp without time zone, timestamp without time zone, character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_epoch(starttimestamp timestamp without time zone, endtimestamp timestamp without time zone, epochname character varying, protocolid integer, subjectid integer) RETURNS integer
    LANGUAGE sql
    AS $_$
	INSERT INTO epoch (epochid, starttimestamp, endtimestamp, epochname, protocolid, subjectid)
		VALUES((select MAX(epochid) +1 FROM epoch), $1, $2, $3, $4, $5);
	SELECT MAX(epochid) from epoch;
	$_$;


ALTER FUNCTION public.add_epoch(starttimestamp timestamp without time zone, endtimestamp timestamp without time zone, epochname character varying, protocolid integer, subjectid integer) OWNER TO postgres;

--
-- Name: add_experiment(integer, date, boolean, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_experiment(experimenterid integer, date date, fsskew boolean, subjectid integer) RETURNS integer
    LANGUAGE sql
    AS $_$
	INSERT INTO experiment (experimentid, experimenterid, date, fsskew, subjectid)
		VALUES((select MAX(experimentid) +1 FROM experiment), $1, $2, $3, $4);
	SELECT MAX(experimentid) from experiment;
	$_$;


ALTER FUNCTION public.add_experiment(experimenterid integer, date date, fsskew boolean, subjectid integer) OWNER TO postgres;

--
-- Name: add_experimenter(character); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_experimenter(character) RETURNS integer
    LANGUAGE sql
    AS $_$
	INSERT INTO experimenter 
		VALUES((select MAX(experimenterid) +1 FROM experimenter), $1);
	SELECT MAX(experimenterid) from experimenter;
	$_$;


ALTER FUNCTION public.add_experimenter(character) OWNER TO postgres;

--
-- Name: add_penetration(integer, integer, integer, integer, integer, double precision, double precision, double precision, integer, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_penetration(subjectid integer, rostral integer, lateral integer, hemisphereid integer, electrodeid integer, alphaangle double precision, betaangle double precision, rotationangle double precision, histologycorrectionrostral integer, histologycorrectionlateral integer, histologycorrectionventral integer, cmtop integer, cmbottom integer) RETURNS integer
    LANGUAGE sql
    AS $_$
	INSERT INTO penetration (penetrationid, subjectid, rostral, lateral, hemisphereid, electrodeid, alphaangle, betaangle, rotationangle, histologycorrectionrostral, histologycorrectionlateral, histologycorrectionventral, cmtop, cmbottom)
		VALUES((select MAX(penetrationid) +1 FROM penetration), $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);
	SELECT MAX(penetrationid) from penetration;
	$_$;


ALTER FUNCTION public.add_penetration(subjectid integer, rostral integer, lateral integer, hemisphereid integer, electrodeid integer, alphaangle double precision, betaangle double precision, rotationangle double precision, histologycorrectionrostral integer, histologycorrectionlateral integer, histologycorrectionventral integer, cmtop integer, cmbottom integer) OWNER TO postgres;

--
-- Name: add_protocol(integer, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_protocol(protocoltypeid integer, protocolmodeid integer, stimulusselectionid integer, protocolname character varying) RETURNS integer
    LANGUAGE sql
    AS $_$
	INSERT INTO protocol (protocolid, protocoltypeid, protocolmodeid, stimulusselectionid, protocolname)
		VALUES((select MAX(protocolid) +1 FROM protocol), $1, $2, $3, $4);
	SELECT MAX(protocolid) from protocol;
	$_$;


ALTER FUNCTION public.add_protocol(protocoltypeid integer, protocolmodeid integer, stimulusselectionid integer, protocolname character varying) OWNER TO postgres;

--
-- Name: add_site(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_site(penetrationid integer, depth integer) RETURNS integer
    LANGUAGE sql
    AS $_$
	INSERT INTO site (siteid, penetrationid, depth)
		VALUES((select MAX(siteid) +1 FROM site), $1, $2);
	SELECT MAX(siteid) from site;
	$_$;


ALTER FUNCTION public.add_site(penetrationid integer, depth integer) OWNER TO postgres;

--
-- Name: add_sort(integer, character varying, integer, character varying, double precision, integer, integer, integer, integer, integer, integer, integer, integer, double precision, integer, double precision, integer, double precision, integer, double precision, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_sort(siteid integer, concatfilename character varying, concatfilechan integer, sortmarkercode character varying, sortquality double precision, isolationtypeid integer, template_start integer, template_show integer, template_pre integer, template_n integer, primarysourcechan integer, n_chans integer, chan1_electrodepadid integer, chan1_threshold double precision, chan2_electrodepadid integer, chan2_threshold double precision, chan3_electrodepadid integer, chan3_threshold double precision, chan4_electrodepadid integer, chan4_threshold double precision, template_resolution double precision, template_interval double precision, template_scale double precision, template_offset double precision) RETURNS integer
    LANGUAGE sql
    AS $_$
	INSERT INTO sort (sortid,
				siteid, 
				concatfilename, 
				concatfilechan, 
				sortmarkercode, 
				sortquality, 
				isolationtypeid, 
				template_start, 
				template_show, 
				template_pre, 
				template_n, 
				primarysourcechan,
				n_chans,
				chan1_electrodepadid, 
				chan1_threshold, 
				chan2_electrodepadid, 
				chan2_threshold,
				chan3_electrodepadid, 
				chan3_threshold, 
				chan4_electrodepadid, 
				chan4_threshold,
				template_resolution,
				template_interval,
				template_scale,
				template_offset)

		VALUES((select MAX(sortid) +1 FROM sort), $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22, $23, $24);
	SELECT MAX(sortid) from sort;
	$_$;


ALTER FUNCTION public.add_sort(siteid integer, concatfilename character varying, concatfilechan integer, sortmarkercode character varying, sortquality double precision, isolationtypeid integer, template_start integer, template_show integer, template_pre integer, template_n integer, primarysourcechan integer, n_chans integer, chan1_electrodepadid integer, chan1_threshold double precision, chan2_electrodepadid integer, chan2_threshold double precision, chan3_electrodepadid integer, chan3_threshold double precision, chan4_electrodepadid integer, chan4_threshold double precision, template_resolution double precision, template_interval double precision, template_scale double precision, template_offset double precision) OWNER TO postgres;

--
-- Name: add_spiketrain(integer, integer, double precision[], integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_spiketrain(trialid integer, spikecount integer, spiketimes double precision[], cellid integer, sortid integer) RETURNS integer
    LANGUAGE sql
    AS $_$
	INSERT INTO spiketrain (spiketrainid,
				trialid,
				spikecount, 
				spiketimes, 
				cellid,
				sortid)
		VALUES((select MAX(spiketrainid) +1 FROM spiketrain), $1, $2, $3, $4, $5);
	SELECT MAX(spiketrainid) from spiketrain;
	$_$;


ALTER FUNCTION public.add_spiketrain(trialid integer, spikecount integer, spiketimes double precision[], cellid integer, sortid integer) OWNER TO postgres;

--
-- Name: add_sstrial(timestamp without time zone, integer, integer, integer, integer, boolean, integer, integer, boolean, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_sstrial(sstrialtime timestamp without time zone, trialid integer, sstriallocationid integer, stimulusid integer, stimulusclass integer, iscorrectiontrial boolean, responseselectionid integer, responseaccuracyid integer, isreinforced boolean, subjectid integer, protocolmodeid integer) RETURNS integer
    LANGUAGE sql
    AS $_$
	INSERT INTO sstrial (sstrialtime, sstrialid, trialid, sstriallocationid, stimulusid, stimulusclass, iscorrectiontrial, responseselectionid, responseaccuracyid, isreinforced, subjectid, protocolmodeid)
		VALUES( $1, (select MAX(sstrialid) +1 FROM sstrial), $2, $3, $4, $5, $6, $7, $8, $9, $10, $11);
	SELECT MAX(sstrialid) from sstrial;
	$_$;


ALTER FUNCTION public.add_sstrial(sstrialtime timestamp without time zone, trialid integer, sstriallocationid integer, stimulusid integer, stimulusclass integer, iscorrectiontrial boolean, responseselectionid integer, responseaccuracyid integer, isreinforced boolean, subjectid integer, protocolmodeid integer) OWNER TO postgres;

--
-- Name: add_stimulus(character, double precision[], double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_stimulus(character, double precision[], double precision) RETURNS integer
    LANGUAGE sql
    AS $_$
	INSERT INTO stimulus 
		VALUES((select MAX(stimulusid) +1 FROM stimulus), $1, $2, $3);
	SELECT MAX(stimulusid) from stimulus;
	$_$;


ALTER FUNCTION public.add_stimulus(character, double precision[], double precision) OWNER TO postgres;

--
-- Name: add_subject(character, integer, integer[], integer[], integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_subject(subjectname character, experimenterid integer, class1stims integer[], class2stims integer[], trainingtypeid integer) RETURNS integer
    LANGUAGE sql
    AS $_$
	INSERT INTO subject (subjectid, subjectname, experimenterid, class1stims, class2stims, trainingtypeid)
		VALUES((select MAX(subjectid) +1 FROM subject), $1, $2, $3, $4, $5);
	SELECT MAX(subjectid) from subject;
	$_$;


ALTER FUNCTION public.add_subject(subjectname character, experimenterid integer, class1stims integer[], class2stims integer[], trainingtypeid integer) OWNER TO postgres;

--
-- Name: add_subject(character, integer, integer[], integer[], integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_subject(subjectname character, experimenterid integer, class1stims integer[], class2stims integer[], trainingtypeid integer, sexid integer) RETURNS integer
    LANGUAGE sql
    AS $_$
	INSERT INTO subject (subjectid, subjectname, experimenterid, class1stims, class2stims, trainingtypeid, sexid)
		VALUES((select MAX(subjectid) +1 FROM subject), $1, $2, $3, $4, $5, $6);
	SELECT MAX(subjectid) from subject;
	$_$;


ALTER FUNCTION public.add_subject(subjectname character, experimenterid integer, class1stims integer[], class2stims integer[], trainingtypeid integer, sexid integer) OWNER TO postgres;

--
-- Name: add_toe(integer, integer, integer, integer, double precision[], integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_toe(cellid integer, stimulusid integer, repetition integer, spikecount integer, spiketimes double precision[], fs integer) RETURNS integer
    LANGUAGE sql SECURITY DEFINER
    SET search_path TO public, pg_temp
    AS $_$
	INSERT INTO toe (toeid, cellid, stimulusid, repetition, spikecount, spiketimes, fs)
		VALUES((select MAX(toeid) +1 FROM toe), $1, $2, $3, $4, $5, $6);
	SELECT MAX(toeid) from toe;
	$_$;


ALTER FUNCTION public.add_toe(cellid integer, stimulusid integer, repetition integer, spikecount integer, spiketimes double precision[], fs integer) OWNER TO postgres;

--
-- Name: add_trial(integer, integer, integer, double precision, double precision, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_trial(epochid integer, stimulusplaybackrate integer, stimulusid integer, relstarttime double precision, relendtime double precision, trialtime timestamp without time zone) RETURNS integer
    LANGUAGE sql
    AS $_$
	INSERT INTO trial (trialid, epochid, stimulusplaybackrate, stimulusid, relstarttime, relendtime, trialtime)
		VALUES((select MAX(trialid) +1 FROM trial), $1, $2, $3, $4, $5, $6);
	SELECT MAX(trialid) from trial;
	$_$;


ALTER FUNCTION public.add_trial(epochid integer, stimulusplaybackrate integer, stimulusid integer, relstarttime double precision, relendtime double precision, trialtime timestamp without time zone) OWNER TO postgres;

--
-- Name: add_trialevent(integer, double precision, integer, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_trialevent(trialid integer, eventtime double precision, trialeventtypeid integer, eventcode1 integer, eventcode2 integer, eventcode3 integer, eventcode4 integer) RETURNS integer
    LANGUAGE sql
    AS $_$
	INSERT INTO trialevent (trialeventid, trialid , eventtime, trialeventtypeid, eventcode1, eventcode2, eventcode3, eventcode4)
		VALUES((select MAX(trialeventid) +1 FROM trialevent), $1, $2, $3, $4, $5, $6, $7);
	SELECT MAX(trialeventid) from trialevent;
	$_$;


ALTER FUNCTION public.add_trialevent(trialid integer, eventtime double precision, trialeventtypeid integer, eventcode1 integer, eventcode2 integer, eventcode3 integer, eventcode4 integer) OWNER TO postgres;

--
-- Name: armor(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION armor(bytea) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pg_armor';


ALTER FUNCTION public.armor(bytea) OWNER TO postgres;

--
-- Name: concat(pg_catalog.tsvector, pg_catalog.tsvector); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION concat(pg_catalog.tsvector, pg_catalog.tsvector) RETURNS pg_catalog.tsvector
    LANGUAGE internal IMMUTABLE STRICT
    AS $$tsvector_concat$$;


ALTER FUNCTION public.concat(pg_catalog.tsvector, pg_catalog.tsvector) OWNER TO postgres;

--
-- Name: crypt(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crypt(text, text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pg_crypt';


ALTER FUNCTION public.crypt(text, text) OWNER TO postgres;

--
-- Name: dearmor(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dearmor(text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pg_dearmor';


ALTER FUNCTION public.dearmor(text) OWNER TO postgres;

--
-- Name: decrypt(bytea, bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION decrypt(bytea, bytea, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pg_decrypt';


ALTER FUNCTION public.decrypt(bytea, bytea, text) OWNER TO postgres;

--
-- Name: decrypt_iv(bytea, bytea, bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION decrypt_iv(bytea, bytea, bytea, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pg_decrypt_iv';


ALTER FUNCTION public.decrypt_iv(bytea, bytea, bytea, text) OWNER TO postgres;

--
-- Name: dex_init(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dex_init(internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/tsearch2', 'tsa_dex_init';


ALTER FUNCTION public.dex_init(internal) OWNER TO postgres;

--
-- Name: dex_lexize(internal, internal, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dex_lexize(internal, internal, integer) RETURNS internal
    LANGUAGE c STRICT
    AS '$libdir/tsearch2', 'tsa_dex_lexize';


ALTER FUNCTION public.dex_lexize(internal, internal, integer) OWNER TO postgres;

--
-- Name: digest(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION digest(text, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pg_digest';


ALTER FUNCTION public.digest(text, text) OWNER TO postgres;

--
-- Name: digest(bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION digest(bytea, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pg_digest';


ALTER FUNCTION public.digest(bytea, text) OWNER TO postgres;

--
-- Name: encrypt(bytea, bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION encrypt(bytea, bytea, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pg_encrypt';


ALTER FUNCTION public.encrypt(bytea, bytea, text) OWNER TO postgres;

--
-- Name: encrypt_iv(bytea, bytea, bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION encrypt_iv(bytea, bytea, bytea, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pg_encrypt_iv';


ALTER FUNCTION public.encrypt_iv(bytea, bytea, bytea, text) OWNER TO postgres;

--
-- Name: gen_random_bytes(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gen_random_bytes(integer) RETURNS bytea
    LANGUAGE c STRICT
    AS '$libdir/pgcrypto', 'pg_random_bytes';


ALTER FUNCTION public.gen_random_bytes(integer) OWNER TO postgres;

--
-- Name: gen_salt(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gen_salt(text) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/pgcrypto', 'pg_gen_salt';


ALTER FUNCTION public.gen_salt(text) OWNER TO postgres;

--
-- Name: gen_salt(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gen_salt(text, integer) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/pgcrypto', 'pg_gen_salt_rounds';


ALTER FUNCTION public.gen_salt(text, integer) OWNER TO postgres;

--
-- Name: get_covers(pg_catalog.tsvector, pg_catalog.tsquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_covers(pg_catalog.tsvector, pg_catalog.tsquery) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/tsearch2', 'tsa_get_covers';


ALTER FUNCTION public.get_covers(pg_catalog.tsvector, pg_catalog.tsquery) OWNER TO postgres;

--
-- Name: headline(oid, text, pg_catalog.tsquery, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION headline(oid, text, pg_catalog.tsquery, text) RETURNS text
    LANGUAGE internal IMMUTABLE STRICT
    AS $$ts_headline_byid_opt$$;


ALTER FUNCTION public.headline(oid, text, pg_catalog.tsquery, text) OWNER TO postgres;

--
-- Name: headline(oid, text, pg_catalog.tsquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION headline(oid, text, pg_catalog.tsquery) RETURNS text
    LANGUAGE internal IMMUTABLE STRICT
    AS $$ts_headline_byid$$;


ALTER FUNCTION public.headline(oid, text, pg_catalog.tsquery) OWNER TO postgres;

--
-- Name: headline(text, text, pg_catalog.tsquery, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION headline(text, text, pg_catalog.tsquery, text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/tsearch2', 'tsa_headline_byname';


ALTER FUNCTION public.headline(text, text, pg_catalog.tsquery, text) OWNER TO postgres;

--
-- Name: headline(text, text, pg_catalog.tsquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION headline(text, text, pg_catalog.tsquery) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/tsearch2', 'tsa_headline_byname';


ALTER FUNCTION public.headline(text, text, pg_catalog.tsquery) OWNER TO postgres;

--
-- Name: headline(text, pg_catalog.tsquery, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION headline(text, pg_catalog.tsquery, text) RETURNS text
    LANGUAGE internal IMMUTABLE STRICT
    AS $$ts_headline_opt$$;


ALTER FUNCTION public.headline(text, pg_catalog.tsquery, text) OWNER TO postgres;

--
-- Name: headline(text, pg_catalog.tsquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION headline(text, pg_catalog.tsquery) RETURNS text
    LANGUAGE internal IMMUTABLE STRICT
    AS $$ts_headline$$;


ALTER FUNCTION public.headline(text, pg_catalog.tsquery) OWNER TO postgres;

--
-- Name: hmac(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION hmac(text, text, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pg_hmac';


ALTER FUNCTION public.hmac(text, text, text) OWNER TO postgres;

--
-- Name: hmac(bytea, bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION hmac(bytea, bytea, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pg_hmac';


ALTER FUNCTION public.hmac(bytea, bytea, text) OWNER TO postgres;

--
-- Name: length(pg_catalog.tsvector); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION length(pg_catalog.tsvector) RETURNS integer
    LANGUAGE internal IMMUTABLE STRICT
    AS $$tsvector_length$$;


ALTER FUNCTION public.length(pg_catalog.tsvector) OWNER TO postgres;

--
-- Name: lexize(oid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lexize(oid, text) RETURNS text[]
    LANGUAGE internal STRICT
    AS $$ts_lexize$$;


ALTER FUNCTION public.lexize(oid, text) OWNER TO postgres;

--
-- Name: lexize(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lexize(text, text) RETURNS text[]
    LANGUAGE c STRICT
    AS '$libdir/tsearch2', 'tsa_lexize_byname';


ALTER FUNCTION public.lexize(text, text) OWNER TO postgres;

--
-- Name: lexize(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION lexize(text) RETURNS text[]
    LANGUAGE c STRICT
    AS '$libdir/tsearch2', 'tsa_lexize_bycurrent';


ALTER FUNCTION public.lexize(text) OWNER TO postgres;

--
-- Name: numnode(pg_catalog.tsquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION numnode(pg_catalog.tsquery) RETURNS integer
    LANGUAGE internal IMMUTABLE STRICT
    AS $$tsquery_numnode$$;


ALTER FUNCTION public.numnode(pg_catalog.tsquery) OWNER TO postgres;

--
-- Name: parse(oid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION parse(oid, text) RETURNS SETOF tokenout
    LANGUAGE internal STRICT
    AS $$ts_parse_byid$$;


ALTER FUNCTION public.parse(oid, text) OWNER TO postgres;

--
-- Name: parse(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION parse(text, text) RETURNS SETOF tokenout
    LANGUAGE internal STRICT
    AS $$ts_parse_byname$$;


ALTER FUNCTION public.parse(text, text) OWNER TO postgres;

--
-- Name: parse(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION parse(text) RETURNS SETOF tokenout
    LANGUAGE c STRICT
    AS '$libdir/tsearch2', 'tsa_parse_current';


ALTER FUNCTION public.parse(text) OWNER TO postgres;

--
-- Name: pgp_key_id(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_key_id(bytea) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pgp_key_id_w';


ALTER FUNCTION public.pgp_key_id(bytea) OWNER TO postgres;

--
-- Name: pgp_pub_decrypt(bytea, bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_pub_decrypt(bytea, bytea) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text';


ALTER FUNCTION public.pgp_pub_decrypt(bytea, bytea) OWNER TO postgres;

--
-- Name: pgp_pub_decrypt(bytea, bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_pub_decrypt(bytea, bytea, text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text';


ALTER FUNCTION public.pgp_pub_decrypt(bytea, bytea, text) OWNER TO postgres;

--
-- Name: pgp_pub_decrypt(bytea, bytea, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_pub_decrypt(bytea, bytea, text, text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pgp_pub_decrypt_text';


ALTER FUNCTION public.pgp_pub_decrypt(bytea, bytea, text, text) OWNER TO postgres;

--
-- Name: pgp_pub_decrypt_bytea(bytea, bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_pub_decrypt_bytea(bytea, bytea) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea';


ALTER FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea) OWNER TO postgres;

--
-- Name: pgp_pub_decrypt_bytea(bytea, bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea';


ALTER FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea, text) OWNER TO postgres;

--
-- Name: pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pgp_pub_decrypt_bytea';


ALTER FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea, text, text) OWNER TO postgres;

--
-- Name: pgp_pub_encrypt(text, bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_pub_encrypt(text, bytea) RETURNS bytea
    LANGUAGE c STRICT
    AS '$libdir/pgcrypto', 'pgp_pub_encrypt_text';


ALTER FUNCTION public.pgp_pub_encrypt(text, bytea) OWNER TO postgres;

--
-- Name: pgp_pub_encrypt(text, bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_pub_encrypt(text, bytea, text) RETURNS bytea
    LANGUAGE c STRICT
    AS '$libdir/pgcrypto', 'pgp_pub_encrypt_text';


ALTER FUNCTION public.pgp_pub_encrypt(text, bytea, text) OWNER TO postgres;

--
-- Name: pgp_pub_encrypt_bytea(bytea, bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_pub_encrypt_bytea(bytea, bytea) RETURNS bytea
    LANGUAGE c STRICT
    AS '$libdir/pgcrypto', 'pgp_pub_encrypt_bytea';


ALTER FUNCTION public.pgp_pub_encrypt_bytea(bytea, bytea) OWNER TO postgres;

--
-- Name: pgp_pub_encrypt_bytea(bytea, bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text) RETURNS bytea
    LANGUAGE c STRICT
    AS '$libdir/pgcrypto', 'pgp_pub_encrypt_bytea';


ALTER FUNCTION public.pgp_pub_encrypt_bytea(bytea, bytea, text) OWNER TO postgres;

--
-- Name: pgp_sym_decrypt(bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_sym_decrypt(bytea, text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pgp_sym_decrypt_text';


ALTER FUNCTION public.pgp_sym_decrypt(bytea, text) OWNER TO postgres;

--
-- Name: pgp_sym_decrypt(bytea, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_sym_decrypt(bytea, text, text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pgp_sym_decrypt_text';


ALTER FUNCTION public.pgp_sym_decrypt(bytea, text, text) OWNER TO postgres;

--
-- Name: pgp_sym_decrypt_bytea(bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_sym_decrypt_bytea(bytea, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pgp_sym_decrypt_bytea';


ALTER FUNCTION public.pgp_sym_decrypt_bytea(bytea, text) OWNER TO postgres;

--
-- Name: pgp_sym_decrypt_bytea(bytea, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_sym_decrypt_bytea(bytea, text, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgcrypto', 'pgp_sym_decrypt_bytea';


ALTER FUNCTION public.pgp_sym_decrypt_bytea(bytea, text, text) OWNER TO postgres;

--
-- Name: pgp_sym_encrypt(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_sym_encrypt(text, text) RETURNS bytea
    LANGUAGE c STRICT
    AS '$libdir/pgcrypto', 'pgp_sym_encrypt_text';


ALTER FUNCTION public.pgp_sym_encrypt(text, text) OWNER TO postgres;

--
-- Name: pgp_sym_encrypt(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_sym_encrypt(text, text, text) RETURNS bytea
    LANGUAGE c STRICT
    AS '$libdir/pgcrypto', 'pgp_sym_encrypt_text';


ALTER FUNCTION public.pgp_sym_encrypt(text, text, text) OWNER TO postgres;

--
-- Name: pgp_sym_encrypt_bytea(bytea, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_sym_encrypt_bytea(bytea, text) RETURNS bytea
    LANGUAGE c STRICT
    AS '$libdir/pgcrypto', 'pgp_sym_encrypt_bytea';


ALTER FUNCTION public.pgp_sym_encrypt_bytea(bytea, text) OWNER TO postgres;

--
-- Name: pgp_sym_encrypt_bytea(bytea, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pgp_sym_encrypt_bytea(bytea, text, text) RETURNS bytea
    LANGUAGE c STRICT
    AS '$libdir/pgcrypto', 'pgp_sym_encrypt_bytea';


ALTER FUNCTION public.pgp_sym_encrypt_bytea(bytea, text, text) OWNER TO postgres;

--
-- Name: plainto_tsquery(oid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION plainto_tsquery(oid, text) RETURNS pg_catalog.tsquery
    LANGUAGE internal IMMUTABLE STRICT
    AS $$plainto_tsquery_byid$$;


ALTER FUNCTION public.plainto_tsquery(oid, text) OWNER TO postgres;

--
-- Name: plainto_tsquery(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION plainto_tsquery(text, text) RETURNS pg_catalog.tsquery
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/tsearch2', 'tsa_plainto_tsquery_name';


ALTER FUNCTION public.plainto_tsquery(text, text) OWNER TO postgres;

--
-- Name: plainto_tsquery(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION plainto_tsquery(text) RETURNS pg_catalog.tsquery
    LANGUAGE internal IMMUTABLE STRICT
    AS $$plainto_tsquery$$;


ALTER FUNCTION public.plainto_tsquery(text) OWNER TO postgres;

--
-- Name: prsd_end(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION prsd_end(internal) RETURNS void
    LANGUAGE c
    AS '$libdir/tsearch2', 'tsa_prsd_end';


ALTER FUNCTION public.prsd_end(internal) OWNER TO postgres;

--
-- Name: prsd_getlexeme(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION prsd_getlexeme(internal, internal, internal) RETURNS integer
    LANGUAGE c
    AS '$libdir/tsearch2', 'tsa_prsd_getlexeme';


ALTER FUNCTION public.prsd_getlexeme(internal, internal, internal) OWNER TO postgres;

--
-- Name: prsd_headline(internal, internal, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION prsd_headline(internal, internal, internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/tsearch2', 'tsa_prsd_headline';


ALTER FUNCTION public.prsd_headline(internal, internal, internal) OWNER TO postgres;

--
-- Name: prsd_lextype(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION prsd_lextype(internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/tsearch2', 'tsa_prsd_lextype';


ALTER FUNCTION public.prsd_lextype(internal) OWNER TO postgres;

--
-- Name: prsd_start(internal, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION prsd_start(internal, integer) RETURNS internal
    LANGUAGE c
    AS '$libdir/tsearch2', 'tsa_prsd_start';


ALTER FUNCTION public.prsd_start(internal, integer) OWNER TO postgres;

--
-- Name: querytree(pg_catalog.tsquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION querytree(pg_catalog.tsquery) RETURNS text
    LANGUAGE internal STRICT
    AS $$tsquerytree$$;


ALTER FUNCTION public.querytree(pg_catalog.tsquery) OWNER TO postgres;

--
-- Name: rank(real[], pg_catalog.tsvector, pg_catalog.tsquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rank(real[], pg_catalog.tsvector, pg_catalog.tsquery) RETURNS real
    LANGUAGE internal IMMUTABLE STRICT
    AS $$ts_rank_wtt$$;


ALTER FUNCTION public.rank(real[], pg_catalog.tsvector, pg_catalog.tsquery) OWNER TO postgres;

--
-- Name: rank(real[], pg_catalog.tsvector, pg_catalog.tsquery, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rank(real[], pg_catalog.tsvector, pg_catalog.tsquery, integer) RETURNS real
    LANGUAGE internal IMMUTABLE STRICT
    AS $$ts_rank_wttf$$;


ALTER FUNCTION public.rank(real[], pg_catalog.tsvector, pg_catalog.tsquery, integer) OWNER TO postgres;

--
-- Name: rank(pg_catalog.tsvector, pg_catalog.tsquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rank(pg_catalog.tsvector, pg_catalog.tsquery) RETURNS real
    LANGUAGE internal IMMUTABLE STRICT
    AS $$ts_rank_tt$$;


ALTER FUNCTION public.rank(pg_catalog.tsvector, pg_catalog.tsquery) OWNER TO postgres;

--
-- Name: rank(pg_catalog.tsvector, pg_catalog.tsquery, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rank(pg_catalog.tsvector, pg_catalog.tsquery, integer) RETURNS real
    LANGUAGE internal IMMUTABLE STRICT
    AS $$ts_rank_ttf$$;


ALTER FUNCTION public.rank(pg_catalog.tsvector, pg_catalog.tsquery, integer) OWNER TO postgres;

--
-- Name: rank_cd(real[], pg_catalog.tsvector, pg_catalog.tsquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rank_cd(real[], pg_catalog.tsvector, pg_catalog.tsquery) RETURNS real
    LANGUAGE internal IMMUTABLE STRICT
    AS $$ts_rankcd_wtt$$;


ALTER FUNCTION public.rank_cd(real[], pg_catalog.tsvector, pg_catalog.tsquery) OWNER TO postgres;

--
-- Name: rank_cd(real[], pg_catalog.tsvector, pg_catalog.tsquery, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rank_cd(real[], pg_catalog.tsvector, pg_catalog.tsquery, integer) RETURNS real
    LANGUAGE internal IMMUTABLE STRICT
    AS $$ts_rankcd_wttf$$;


ALTER FUNCTION public.rank_cd(real[], pg_catalog.tsvector, pg_catalog.tsquery, integer) OWNER TO postgres;

--
-- Name: rank_cd(pg_catalog.tsvector, pg_catalog.tsquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rank_cd(pg_catalog.tsvector, pg_catalog.tsquery) RETURNS real
    LANGUAGE internal IMMUTABLE STRICT
    AS $$ts_rankcd_tt$$;


ALTER FUNCTION public.rank_cd(pg_catalog.tsvector, pg_catalog.tsquery) OWNER TO postgres;

--
-- Name: rank_cd(pg_catalog.tsvector, pg_catalog.tsquery, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rank_cd(pg_catalog.tsvector, pg_catalog.tsquery, integer) RETURNS real
    LANGUAGE internal IMMUTABLE STRICT
    AS $$ts_rankcd_ttf$$;


ALTER FUNCTION public.rank_cd(pg_catalog.tsvector, pg_catalog.tsquery, integer) OWNER TO postgres;

--
-- Name: reset_tsearch(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION reset_tsearch() RETURNS void
    LANGUAGE c STRICT
    AS '$libdir/tsearch2', 'tsa_reset_tsearch';


ALTER FUNCTION public.reset_tsearch() OWNER TO postgres;

--
-- Name: rewrite(pg_catalog.tsquery, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rewrite(pg_catalog.tsquery, text) RETURNS pg_catalog.tsquery
    LANGUAGE internal IMMUTABLE STRICT
    AS $$tsquery_rewrite_query$$;


ALTER FUNCTION public.rewrite(pg_catalog.tsquery, text) OWNER TO postgres;

--
-- Name: rewrite(pg_catalog.tsquery, pg_catalog.tsquery, pg_catalog.tsquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rewrite(pg_catalog.tsquery, pg_catalog.tsquery, pg_catalog.tsquery) RETURNS pg_catalog.tsquery
    LANGUAGE internal IMMUTABLE STRICT
    AS $$tsquery_rewrite$$;


ALTER FUNCTION public.rewrite(pg_catalog.tsquery, pg_catalog.tsquery, pg_catalog.tsquery) OWNER TO postgres;

--
-- Name: rewrite_accum(pg_catalog.tsquery, pg_catalog.tsquery[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rewrite_accum(pg_catalog.tsquery, pg_catalog.tsquery[]) RETURNS pg_catalog.tsquery
    LANGUAGE c
    AS '$libdir/tsearch2', 'tsa_rewrite_accum';


ALTER FUNCTION public.rewrite_accum(pg_catalog.tsquery, pg_catalog.tsquery[]) OWNER TO postgres;

--
-- Name: rewrite_finish(pg_catalog.tsquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rewrite_finish(pg_catalog.tsquery) RETURNS pg_catalog.tsquery
    LANGUAGE c
    AS '$libdir/tsearch2', 'tsa_rewrite_finish';


ALTER FUNCTION public.rewrite_finish(pg_catalog.tsquery) OWNER TO postgres;

--
-- Name: set_curcfg(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION set_curcfg(integer) RETURNS void
    LANGUAGE c STRICT
    AS '$libdir/tsearch2', 'tsa_set_curcfg';


ALTER FUNCTION public.set_curcfg(integer) OWNER TO postgres;

--
-- Name: set_curcfg(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION set_curcfg(text) RETURNS void
    LANGUAGE c STRICT
    AS '$libdir/tsearch2', 'tsa_set_curcfg_byname';


ALTER FUNCTION public.set_curcfg(text) OWNER TO postgres;

--
-- Name: set_curdict(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION set_curdict(integer) RETURNS void
    LANGUAGE c STRICT
    AS '$libdir/tsearch2', 'tsa_set_curdict';


ALTER FUNCTION public.set_curdict(integer) OWNER TO postgres;

--
-- Name: set_curdict(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION set_curdict(text) RETURNS void
    LANGUAGE c STRICT
    AS '$libdir/tsearch2', 'tsa_set_curdict_byname';


ALTER FUNCTION public.set_curdict(text) OWNER TO postgres;

--
-- Name: set_curprs(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION set_curprs(integer) RETURNS void
    LANGUAGE c STRICT
    AS '$libdir/tsearch2', 'tsa_set_curprs';


ALTER FUNCTION public.set_curprs(integer) OWNER TO postgres;

--
-- Name: set_curprs(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION set_curprs(text) RETURNS void
    LANGUAGE c STRICT
    AS '$libdir/tsearch2', 'tsa_set_curprs_byname';


ALTER FUNCTION public.set_curprs(text) OWNER TO postgres;

--
-- Name: setweight(pg_catalog.tsvector, "char"); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION setweight(pg_catalog.tsvector, "char") RETURNS pg_catalog.tsvector
    LANGUAGE internal IMMUTABLE STRICT
    AS $$tsvector_setweight$$;


ALTER FUNCTION public.setweight(pg_catalog.tsvector, "char") OWNER TO postgres;

--
-- Name: show_curcfg(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION show_curcfg() RETURNS oid
    LANGUAGE internal STABLE STRICT
    AS $$get_current_ts_config$$;


ALTER FUNCTION public.show_curcfg() OWNER TO postgres;

--
-- Name: snb_en_init(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION snb_en_init(internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/tsearch2', 'tsa_snb_en_init';


ALTER FUNCTION public.snb_en_init(internal) OWNER TO postgres;

--
-- Name: snb_lexize(internal, internal, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION snb_lexize(internal, internal, integer) RETURNS internal
    LANGUAGE c STRICT
    AS '$libdir/tsearch2', 'tsa_snb_lexize';


ALTER FUNCTION public.snb_lexize(internal, internal, integer) OWNER TO postgres;

--
-- Name: snb_ru_init(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION snb_ru_init(internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/tsearch2', 'tsa_snb_ru_init';


ALTER FUNCTION public.snb_ru_init(internal) OWNER TO postgres;

--
-- Name: snb_ru_init_koi8(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION snb_ru_init_koi8(internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/tsearch2', 'tsa_snb_ru_init_koi8';


ALTER FUNCTION public.snb_ru_init_koi8(internal) OWNER TO postgres;

--
-- Name: snb_ru_init_utf8(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION snb_ru_init_utf8(internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/tsearch2', 'tsa_snb_ru_init_utf8';


ALTER FUNCTION public.snb_ru_init_utf8(internal) OWNER TO postgres;

--
-- Name: spell_init(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION spell_init(internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/tsearch2', 'tsa_spell_init';


ALTER FUNCTION public.spell_init(internal) OWNER TO postgres;

--
-- Name: spell_lexize(internal, internal, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION spell_lexize(internal, internal, integer) RETURNS internal
    LANGUAGE c STRICT
    AS '$libdir/tsearch2', 'tsa_spell_lexize';


ALTER FUNCTION public.spell_lexize(internal, internal, integer) OWNER TO postgres;

--
-- Name: stat(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION stat(text) RETURNS SETOF statinfo
    LANGUAGE internal STRICT
    AS $$ts_stat1$$;


ALTER FUNCTION public.stat(text) OWNER TO postgres;

--
-- Name: stat(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION stat(text, text) RETURNS SETOF statinfo
    LANGUAGE internal STRICT
    AS $$ts_stat2$$;


ALTER FUNCTION public.stat(text, text) OWNER TO postgres;

--
-- Name: strip(pg_catalog.tsvector); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION strip(pg_catalog.tsvector) RETURNS pg_catalog.tsvector
    LANGUAGE internal IMMUTABLE STRICT
    AS $$tsvector_strip$$;


ALTER FUNCTION public.strip(pg_catalog.tsvector) OWNER TO postgres;

--
-- Name: syn_init(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION syn_init(internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/tsearch2', 'tsa_syn_init';


ALTER FUNCTION public.syn_init(internal) OWNER TO postgres;

--
-- Name: syn_lexize(internal, internal, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION syn_lexize(internal, internal, integer) RETURNS internal
    LANGUAGE c STRICT
    AS '$libdir/tsearch2', 'tsa_syn_lexize';


ALTER FUNCTION public.syn_lexize(internal, internal, integer) OWNER TO postgres;

--
-- Name: thesaurus_init(internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION thesaurus_init(internal) RETURNS internal
    LANGUAGE c
    AS '$libdir/tsearch2', 'tsa_thesaurus_init';


ALTER FUNCTION public.thesaurus_init(internal) OWNER TO postgres;

--
-- Name: thesaurus_lexize(internal, internal, integer, internal); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION thesaurus_lexize(internal, internal, integer, internal) RETURNS internal
    LANGUAGE c STRICT
    AS '$libdir/tsearch2', 'tsa_thesaurus_lexize';


ALTER FUNCTION public.thesaurus_lexize(internal, internal, integer, internal) OWNER TO postgres;

--
-- Name: to_tsquery(oid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION to_tsquery(oid, text) RETURNS pg_catalog.tsquery
    LANGUAGE internal IMMUTABLE STRICT
    AS $$to_tsquery_byid$$;


ALTER FUNCTION public.to_tsquery(oid, text) OWNER TO postgres;

--
-- Name: to_tsquery(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION to_tsquery(text, text) RETURNS pg_catalog.tsquery
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/tsearch2', 'tsa_to_tsquery_name';


ALTER FUNCTION public.to_tsquery(text, text) OWNER TO postgres;

--
-- Name: to_tsquery(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION to_tsquery(text) RETURNS pg_catalog.tsquery
    LANGUAGE internal IMMUTABLE STRICT
    AS $$to_tsquery$$;


ALTER FUNCTION public.to_tsquery(text) OWNER TO postgres;

--
-- Name: to_tsvector(oid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION to_tsvector(oid, text) RETURNS pg_catalog.tsvector
    LANGUAGE internal IMMUTABLE STRICT
    AS $$to_tsvector_byid$$;


ALTER FUNCTION public.to_tsvector(oid, text) OWNER TO postgres;

--
-- Name: to_tsvector(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION to_tsvector(text, text) RETURNS pg_catalog.tsvector
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/tsearch2', 'tsa_to_tsvector_name';


ALTER FUNCTION public.to_tsvector(text, text) OWNER TO postgres;

--
-- Name: to_tsvector(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION to_tsvector(text) RETURNS pg_catalog.tsvector
    LANGUAGE internal IMMUTABLE STRICT
    AS $$to_tsvector$$;


ALTER FUNCTION public.to_tsvector(text) OWNER TO postgres;

--
-- Name: token_type(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION token_type(integer) RETURNS SETOF tokentype
    LANGUAGE internal STRICT ROWS 16
    AS $$ts_token_type_byid$$;


ALTER FUNCTION public.token_type(integer) OWNER TO postgres;

--
-- Name: token_type(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION token_type(text) RETURNS SETOF tokentype
    LANGUAGE internal STRICT ROWS 16
    AS $$ts_token_type_byname$$;


ALTER FUNCTION public.token_type(text) OWNER TO postgres;

--
-- Name: token_type(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION token_type() RETURNS SETOF tokentype
    LANGUAGE c STRICT ROWS 16
    AS '$libdir/tsearch2', 'tsa_token_type_current';


ALTER FUNCTION public.token_type() OWNER TO postgres;

--
-- Name: ts_debug(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ts_debug(text) RETURNS SETOF tsdebug
    LANGUAGE sql STRICT
    AS $_$
select
        (select c.cfgname::text from pg_catalog.pg_ts_config as c
         where c.oid = show_curcfg()),
        t.alias as tok_type,
        t.descr as description,
        p.token,
        ARRAY ( SELECT m.mapdict::pg_catalog.regdictionary::pg_catalog.text
                FROM pg_catalog.pg_ts_config_map AS m
                WHERE m.mapcfg = show_curcfg() AND m.maptokentype = p.tokid
                ORDER BY m.mapseqno )
        AS dict_name,
        strip(to_tsvector(p.token)) as tsvector
from
        parse( _get_parser_from_curcfg(), $1 ) as p,
        token_type() as t
where
        t.tokid = p.tokid
$_$;


ALTER FUNCTION public.ts_debug(text) OWNER TO postgres;

--
-- Name: tsearch2(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION tsearch2() RETURNS trigger
    LANGUAGE c
    AS '$libdir/tsearch2', 'tsa_tsearch2';


ALTER FUNCTION public.tsearch2() OWNER TO postgres;

--
-- Name: tsq_mcontained(pg_catalog.tsquery, pg_catalog.tsquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION tsq_mcontained(pg_catalog.tsquery, pg_catalog.tsquery) RETURNS boolean
    LANGUAGE internal IMMUTABLE STRICT
    AS $$tsq_mcontained$$;


ALTER FUNCTION public.tsq_mcontained(pg_catalog.tsquery, pg_catalog.tsquery) OWNER TO postgres;

--
-- Name: tsq_mcontains(pg_catalog.tsquery, pg_catalog.tsquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION tsq_mcontains(pg_catalog.tsquery, pg_catalog.tsquery) RETURNS boolean
    LANGUAGE internal IMMUTABLE STRICT
    AS $$tsq_mcontains$$;


ALTER FUNCTION public.tsq_mcontains(pg_catalog.tsquery, pg_catalog.tsquery) OWNER TO postgres;

--
-- Name: tsquery_and(pg_catalog.tsquery, pg_catalog.tsquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION tsquery_and(pg_catalog.tsquery, pg_catalog.tsquery) RETURNS pg_catalog.tsquery
    LANGUAGE internal IMMUTABLE STRICT
    AS $$tsquery_and$$;


ALTER FUNCTION public.tsquery_and(pg_catalog.tsquery, pg_catalog.tsquery) OWNER TO postgres;

--
-- Name: tsquery_not(pg_catalog.tsquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION tsquery_not(pg_catalog.tsquery) RETURNS pg_catalog.tsquery
    LANGUAGE internal IMMUTABLE STRICT
    AS $$tsquery_not$$;


ALTER FUNCTION public.tsquery_not(pg_catalog.tsquery) OWNER TO postgres;

--
-- Name: tsquery_or(pg_catalog.tsquery, pg_catalog.tsquery); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION tsquery_or(pg_catalog.tsquery, pg_catalog.tsquery) RETURNS pg_catalog.tsquery
    LANGUAGE internal IMMUTABLE STRICT
    AS $$tsquery_or$$;


ALTER FUNCTION public.tsquery_or(pg_catalog.tsquery, pg_catalog.tsquery) OWNER TO postgres;

--
-- Name: xml_encode_special_chars(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xml_encode_special_chars(text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgxml', 'xml_encode_special_chars';


ALTER FUNCTION public.xml_encode_special_chars(text) OWNER TO postgres;

--
-- Name: xml_is_well_formed(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xml_is_well_formed(text) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgxml', 'xml_is_well_formed';


ALTER FUNCTION public.xml_is_well_formed(text) OWNER TO postgres;

--
-- Name: xml_valid(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xml_valid(text) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgxml', 'xml_is_well_formed';


ALTER FUNCTION public.xml_valid(text) OWNER TO postgres;

--
-- Name: xpath_bool(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xpath_bool(text, text) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgxml', 'xpath_bool';


ALTER FUNCTION public.xpath_bool(text, text) OWNER TO postgres;

--
-- Name: xpath_list(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xpath_list(text, text, text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgxml', 'xpath_list';


ALTER FUNCTION public.xpath_list(text, text, text) OWNER TO postgres;

--
-- Name: xpath_list(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xpath_list(text, text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT xpath_list($1,$2,',')$_$;


ALTER FUNCTION public.xpath_list(text, text) OWNER TO postgres;

--
-- Name: xpath_nodeset(text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xpath_nodeset(text, text, text, text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgxml', 'xpath_nodeset';


ALTER FUNCTION public.xpath_nodeset(text, text, text, text) OWNER TO postgres;

--
-- Name: xpath_nodeset(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xpath_nodeset(text, text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT xpath_nodeset($1,$2,'','')$_$;


ALTER FUNCTION public.xpath_nodeset(text, text) OWNER TO postgres;

--
-- Name: xpath_nodeset(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xpath_nodeset(text, text, text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT xpath_nodeset($1,$2,'',$3)$_$;


ALTER FUNCTION public.xpath_nodeset(text, text, text) OWNER TO postgres;

--
-- Name: xpath_number(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xpath_number(text, text) RETURNS real
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgxml', 'xpath_number';


ALTER FUNCTION public.xpath_number(text, text) OWNER TO postgres;

--
-- Name: xpath_string(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xpath_string(text, text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgxml', 'xpath_string';


ALTER FUNCTION public.xpath_string(text, text) OWNER TO postgres;

--
-- Name: xpath_table(text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xpath_table(text, text, text, text, text) RETURNS SETOF record
    LANGUAGE c STABLE STRICT
    AS '$libdir/pgxml', 'xpath_table';


ALTER FUNCTION public.xpath_table(text, text, text, text, text) OWNER TO postgres;

--
-- Name: xslt_process(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xslt_process(text, text, text) RETURNS text
    LANGUAGE c STRICT
    AS '$libdir/pgxml', 'xslt_process';


ALTER FUNCTION public.xslt_process(text, text, text) OWNER TO postgres;

--
-- Name: xslt_process(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xslt_process(text, text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/pgxml', 'xslt_process';


ALTER FUNCTION public.xslt_process(text, text) OWNER TO postgres;

--
-- Name: rewrite(pg_catalog.tsquery[]); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE rewrite(pg_catalog.tsquery[]) (
    SFUNC = rewrite_accum,
    STYPE = pg_catalog.tsquery,
    FINALFUNC = rewrite_finish
);


ALTER AGGREGATE public.rewrite(pg_catalog.tsquery[]) OWNER TO postgres;

--
-- Name: tsquery_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS tsquery_ops
    FOR TYPE pg_catalog.tsquery USING btree AS
    OPERATOR 1 <(pg_catalog.tsquery,pg_catalog.tsquery) ,
    OPERATOR 2 <=(pg_catalog.tsquery,pg_catalog.tsquery) ,
    OPERATOR 3 =(pg_catalog.tsquery,pg_catalog.tsquery) ,
    OPERATOR 4 >=(pg_catalog.tsquery,pg_catalog.tsquery) ,
    OPERATOR 5 >(pg_catalog.tsquery,pg_catalog.tsquery) ,
    FUNCTION 1 tsquery_cmp(pg_catalog.tsquery,pg_catalog.tsquery);


ALTER OPERATOR CLASS public.tsquery_ops USING btree OWNER TO postgres;

--
-- Name: tsvector_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS tsvector_ops
    FOR TYPE pg_catalog.tsvector USING btree AS
    OPERATOR 1 <(pg_catalog.tsvector,pg_catalog.tsvector) ,
    OPERATOR 2 <=(pg_catalog.tsvector,pg_catalog.tsvector) ,
    OPERATOR 3 =(pg_catalog.tsvector,pg_catalog.tsvector) ,
    OPERATOR 4 >=(pg_catalog.tsvector,pg_catalog.tsvector) ,
    OPERATOR 5 >(pg_catalog.tsvector,pg_catalog.tsvector) ,
    FUNCTION 1 tsvector_cmp(pg_catalog.tsvector,pg_catalog.tsvector);


ALTER OPERATOR CLASS public.tsvector_ops USING btree OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: behavioralconsequence; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE behavioralconsequence (
    behavioralconsequenceid integer NOT NULL,
    behavioralconsequencename character varying(200)
);


ALTER TABLE public.behavioralconsequence OWNER TO postgres;

--
-- Name: cell; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE cell (
    cellid integer NOT NULL,
    cellname character varying(100),
    regionid integer,
    siteid integer,
    sortmarkercode character varying(5)
);


ALTER TABLE public.cell OWNER TO postgres;

--
-- Name: cellcalc; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE cellcalc (
    cellcalcid integer NOT NULL,
    cellid integer,
    engmodeid integer,
    correctedposition_rostral integer,
    correctedposition_lateral integer,
    correctedposition_ventral integer,
    regionid integer,
    minsortquality double precision,
    maxsortquality double precision,
    byeyeaud integer
);


ALTER TABLE public.cellcalc OWNER TO postgres;

--
-- Name: engmode; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE engmode (
    engmodeid integer NOT NULL,
    engmodename character varying
);


ALTER TABLE public.engmode OWNER TO postgres;

--
-- Name: penetration; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE penetration (
    penetrationid integer NOT NULL,
    rostral integer,
    lateral integer,
    hemisphereid integer,
    electrodeid integer,
    alphaangle double precision,
    betaangle double precision,
    rotationangle double precision,
    subjectid integer,
    histologycorrectionrostral integer,
    histologycorrectionlateral integer,
    histologycorrectionventral integer,
    cmtop integer,
    cmbottom integer
);


ALTER TABLE public.penetration OWNER TO postgres;

--
-- Name: region; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE region (
    regionid integer NOT NULL,
    regionname character varying(80)
);


ALTER TABLE public.region OWNER TO postgres;

--
-- Name: site; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE site (
    siteid integer NOT NULL,
    penetrationid integer,
    depth integer
);


ALTER TABLE public.site OWNER TO postgres;

--
-- Name: sort; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sort (
    sortid integer NOT NULL,
    siteid integer,
    concatfilename character varying(500),
    concatfilechan integer,
    sortmarkercode character varying(5),
    sortquality double precision,
    isolationtypeid integer,
    template_start integer,
    template_show integer,
    template_pre integer,
    template_n integer,
    chan1_electrodepadid integer,
    chan1_threshold double precision,
    chan2_electrodepadid integer,
    chan2_threshold double precision,
    primarysourcechan integer,
    chan3_electrodepadid integer,
    chan3_threshold double precision,
    chan4_electrodepadid integer,
    chan4_threshold double precision,
    n_chans integer,
    template_resolution double precision,
    template_interval double precision,
    template_scale double precision,
    template_offset double precision
);


ALTER TABLE public.sort OWNER TO postgres;

--
-- Name: subject; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE subject (
    subjectname character varying(10) NOT NULL,
    experimenterid integer,
    class1stims integer[],
    class2stims integer[],
    subjectid integer NOT NULL,
    trainingtypeid integer DEFAULT 1 NOT NULL,
    sexid integer
);


ALTER TABLE public.subject OWNER TO postgres;

--
-- Name: trainingtype; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE trainingtype (
    trainingtypeid integer NOT NULL,
    trainingtypename character varying(40)
);


ALTER TABLE public.trainingtype OWNER TO postgres;

--
-- Name: cellmeta; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW cellmeta AS
    SELECT DISTINCT subject.subjectname, trainingtype.trainingtypename AS training, region.regionname AS region, engmode.engmodename AS engmode, cellcalc.minsortquality AS minquality, cellcalc.maxsortquality AS maxquality, cellcalc.correctedposition_rostral AS hc_rostral, cellcalc.correctedposition_lateral AS hc_lateral, cellcalc.correctedposition_ventral AS hc_ventral, cell.cellid, subject.subjectid, trainingtype.trainingtypeid, penetration.penetrationid, site.siteid, cellcalc.regionid, engmode.engmodeid, cell.sortmarkercode, cellcalc.byeyeaud FROM ((((((((cell JOIN sort ON ((((cell.sortmarkercode)::text = (sort.sortmarkercode)::text) AND (cell.siteid = sort.siteid)))) JOIN site ON ((sort.siteid = site.siteid))) JOIN penetration ON ((penetration.penetrationid = site.penetrationid))) JOIN subject ON ((subject.subjectid = penetration.subjectid))) JOIN cellcalc ON ((cellcalc.cellid = cell.cellid))) JOIN region ON ((region.regionid = cellcalc.regionid))) JOIN engmode ON ((engmode.engmodeid = cellcalc.engmodeid))) JOIN trainingtype ON ((trainingtype.trainingtypeid = subject.trainingtypeid))) ORDER BY subject.subjectname, cellcalc.correctedposition_rostral, cellcalc.correctedposition_lateral, cellcalc.correctedposition_ventral, cellcalc.regionid, engmode.engmodeid, cell.sortmarkercode, cell.cellid, subject.subjectid, penetration.penetrationid, site.siteid, trainingtype.trainingtypename, region.regionname, engmode.engmodename, trainingtype.trainingtypeid, cellcalc.minsortquality, cellcalc.maxsortquality, cellcalc.byeyeaud;


ALTER TABLE public.cellmeta OWNER TO postgres;

--
-- Name: cellmetab; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW cellmetab AS
    SELECT DISTINCT subject.subjectname, trainingtype.trainingtypename AS training, region.regionname AS region, engmode.engmodename AS engmode, cellcalc.minsortquality AS minquality, cellcalc.maxsortquality AS maxquality, cell.cellid, subject.subjectid, trainingtype.trainingtypeid, penetration.penetrationid, site.siteid, cellcalc.regionid, engmode.engmodeid, cell.sortmarkercode, cellcalc.byeyeaud FROM ((((((((cell JOIN sort ON ((((cell.sortmarkercode)::text = (sort.sortmarkercode)::text) AND (cell.siteid = sort.siteid)))) JOIN site ON ((sort.siteid = site.siteid))) JOIN penetration ON ((penetration.penetrationid = site.penetrationid))) JOIN subject ON ((subject.subjectid = penetration.subjectid))) JOIN cellcalc ON ((cellcalc.cellid = cell.cellid))) JOIN region ON ((region.regionid = cellcalc.regionid))) JOIN engmode ON ((engmode.engmodeid = cellcalc.engmodeid))) JOIN trainingtype ON ((trainingtype.trainingtypeid = subject.trainingtypeid))) ORDER BY subject.subjectname, cellcalc.regionid, engmode.engmodeid, cell.sortmarkercode, cell.cellid, subject.subjectid, penetration.penetrationid, site.siteid, trainingtype.trainingtypename, region.regionname, engmode.engmodename, trainingtype.trainingtypeid, cellcalc.minsortquality, cellcalc.maxsortquality, cellcalc.byeyeaud;


ALTER TABLE public.cellmetab OWNER TO postgres;

--
-- Name: electrode; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE electrode (
    electrodeid integer NOT NULL,
    electrodetypeid integer,
    impedence double precision,
    serialnumber character varying(50)
);


ALTER TABLE public.electrode OWNER TO postgres;

--
-- Name: electrodepad; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE electrodepad (
    electrodepadid integer NOT NULL,
    electrodetypeid integer,
    nnsitenumber integer,
    xposition integer,
    yposition integer,
    datachannel integer
);


ALTER TABLE public.electrodepad OWNER TO postgres;

--
-- Name: electrodetype; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE electrodetype (
    electrodetypeid integer NOT NULL,
    electrodetypename character varying(500),
    shaftlength integer,
    shaftspacing integer,
    padarea integer,
    numpads integer,
    numshafts integer
);


ALTER TABLE public.electrodetype OWNER TO postgres;

--
-- Name: epoch; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE epoch (
    epochid integer NOT NULL,
    starttimestamp timestamp without time zone,
    endtimestamp timestamp without time zone,
    protocolid integer,
    epochname character varying(500),
    subjectid integer
);


ALTER TABLE public.epoch OWNER TO postgres;

--
-- Name: experiment; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE experiment (
    experimentid integer NOT NULL,
    subjectid integer,
    experimentname text DEFAULT 'Not Yet Named'::text,
    experimenterid integer
);


ALTER TABLE public.experiment OWNER TO postgres;

--
-- Name: experimenter; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE experimenter (
    experimenterid integer NOT NULL,
    experimentername character varying(100)
);


ALTER TABLE public.experimenter OWNER TO postgres;

--
-- Name: hemisphere; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE hemisphere (
    hemisphereid integer NOT NULL,
    hemispherename character varying(10)
);


ALTER TABLE public.hemisphere OWNER TO postgres;

--
-- Name: isolationtype; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE isolationtype (
    isolationtypeid integer NOT NULL,
    isolationtypename character varying(100)
);


ALTER TABLE public.isolationtype OWNER TO postgres;

--
-- Name: penetrationmeta; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW penetrationmeta AS
    SELECT DISTINCT penetration.penetrationid, subject.subjectid, subject.subjectname, hemisphere.hemispherename, penetration.rostral, penetration.lateral, electrode.serialnumber, penetration.alphaangle, penetration.betaangle, penetration.rotationangle, penetration.histologycorrectionrostral, penetration.histologycorrectionlateral, penetration.histologycorrectionventral, penetration.cmtop, penetration.cmbottom FROM (((penetration JOIN subject ON ((subject.subjectid = penetration.subjectid))) JOIN hemisphere ON ((hemisphere.hemisphereid = penetration.hemisphereid))) JOIN electrode ON ((electrode.electrodeid = penetration.electrodeid))) ORDER BY subject.subjectname, penetration.rostral, penetration.lateral, electrode.serialnumber, penetration.penetrationid, subject.subjectid, hemisphere.hemispherename, penetration.alphaangle, penetration.betaangle, penetration.rotationangle, penetration.histologycorrectionrostral, penetration.histologycorrectionlateral, penetration.histologycorrectionventral, penetration.cmtop, penetration.cmbottom;


ALTER TABLE public.penetrationmeta OWNER TO postgres;

--
-- Name: pepcalc; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pepcalc (
    pepcalcid integer NOT NULL,
    cellid integer NOT NULL,
    pepnum integer,
    firstpep boolean,
    lastpep boolean,
    engmodeid integer NOT NULL,
    pepstarttimestamp timestamp without time zone,
    pependtimestamp timestamp without time zone
);


ALTER TABLE public.pepcalc OWNER TO postgres;

--
-- Name: protocol; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE protocol (
    protocolid integer NOT NULL,
    protocoltypeid integer,
    protocolmodeid integer,
    stimulusselectionid integer,
    protocolname character varying(500)
);


ALTER TABLE public.protocol OWNER TO postgres;

--
-- Name: protocolmode; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE protocolmode (
    protocolmodeid integer NOT NULL,
    protocolmodename character varying(200)
);


ALTER TABLE public.protocolmode OWNER TO postgres;

--
-- Name: protocoltype; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE protocoltype (
    protocoltypeid integer NOT NULL,
    protocoltypename character varying(200)
);


ALTER TABLE public.protocoltype OWNER TO postgres;

--
-- Name: responseaccuracy; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE responseaccuracy (
    responseaccuracyid integer NOT NULL,
    responseaccuracyname character varying
);


ALTER TABLE public.responseaccuracy OWNER TO postgres;

--
-- Name: responseselection; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE responseselection (
    responseselectionid integer NOT NULL,
    responseselectionname character varying
);


ALTER TABLE public.responseselection OWNER TO postgres;

--
-- Name: setcalc; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE setcalc (
    setcalcid integer NOT NULL,
    subjectid integer,
    starttime timestamp without time zone,
    endtime timestamp without time zone
);


ALTER TABLE public.setcalc OWNER TO postgres;

--
-- Name: setcalcstims; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE setcalcstims (
    setcalcid integer NOT NULL,
    stimulusid integer NOT NULL,
    setclassid integer NOT NULL
);


ALTER TABLE public.setcalcstims OWNER TO postgres;

--
-- Name: setclass; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE setclass (
    setclassid integer NOT NULL,
    setclassname character varying(20)
);


ALTER TABLE public.setclass OWNER TO postgres;

--
-- Name: sex; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sex (
    sexid integer NOT NULL,
    sexname character varying(10)
);


ALTER TABLE public.sex OWNER TO postgres;

--
-- Name: sortmeta; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW sortmeta AS
    SELECT DISTINCT cell.cellid, sort.sortid, sort.sortquality, isolationtype.isolationtypename, sort.isolationtypeid, sort.concatfilename FROM ((sort JOIN cell ON ((((cell.sortmarkercode)::text = (sort.sortmarkercode)::text) AND (cell.siteid = sort.siteid)))) JOIN isolationtype ON ((isolationtype.isolationtypeid = sort.isolationtypeid))) ORDER BY sort.sortid, cell.cellid, sort.isolationtypeid, sort.sortquality, isolationtype.isolationtypename;


ALTER TABLE public.sortmeta OWNER TO postgres;

--
-- Name: sortmeta_temp; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW sortmeta_temp AS
    SELECT DISTINCT cell.cellid, sort.sortid, sort.sortquality, isolationtype.isolationtypename, sort.isolationtypeid, subject.subjectid, subject.subjectname, sort.concatfilename FROM (((((sort JOIN cell ON ((((cell.sortmarkercode)::text = (sort.sortmarkercode)::text) AND (cell.siteid = sort.siteid)))) JOIN site ON ((sort.siteid = site.siteid))) JOIN penetration ON ((site.penetrationid = penetration.penetrationid))) JOIN subject ON ((subject.subjectid = penetration.subjectid))) JOIN isolationtype ON ((isolationtype.isolationtypeid = sort.isolationtypeid))) ORDER BY subject.subjectid, sort.sortid, cell.cellid, sort.isolationtypeid, sort.sortquality, isolationtype.isolationtypename;


ALTER TABLE public.sortmeta_temp OWNER TO postgres;

--
-- Name: spiketrain; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE spiketrain (
    spiketrainid integer NOT NULL,
    trialid integer,
    spikecount integer,
    spiketimes double precision[],
    cellid integer,
    sortid integer
);


ALTER TABLE public.spiketrain OWNER TO postgres;

--
-- Name: trial; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE trial (
    trialid integer NOT NULL,
    epochid integer,
    stimulusplaybackrate integer,
    stimulusid integer,
    relstarttime double precision,
    relendtime double precision,
    trialtime timestamp without time zone
);


ALTER TABLE public.trial OWNER TO postgres;

--
-- Name: spiketrainmeta; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW spiketrainmeta AS
    SELECT DISTINCT trial.trialtime, spiketrain.spiketrainid, spiketrain.spikecount, spiketrain.spiketimes, trial.relstarttime, trial.relendtime, trial.trialid, spiketrain.cellid, spiketrain.sortid, trial.epochid, trial.stimulusid FROM (spiketrain JOIN trial ON ((spiketrain.trialid = trial.trialid))) ORDER BY trial.trialtime, spiketrain.cellid, spiketrain.spiketrainid, spiketrain.spikecount, spiketrain.spiketimes, trial.relstarttime, trial.relendtime, spiketrain.sortid, trial.epochid, trial.stimulusid, trial.trialid;


ALTER TABLE public.spiketrainmeta OWNER TO postgres;

--
-- Name: spiketrainmetab; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW spiketrainmetab AS
    SELECT DISTINCT spiketrain.spiketrainid, trial.trialid, cell.cellid, sort.sortid, sort.sortquality FROM (((sort JOIN spiketrain ON ((spiketrain.sortid = sort.sortid))) JOIN trial ON ((spiketrain.trialid = trial.trialid))) JOIN cell ON ((cell.cellid = spiketrain.cellid))) ORDER BY spiketrain.spiketrainid, trial.trialid, cell.cellid, sort.sortid, sort.sortquality;


ALTER TABLE public.spiketrainmetab OWNER TO postgres;

--
-- Name: sseffectiveclass; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sseffectiveclass (
    sseffectiveclassid integer NOT NULL,
    sseffectiveclassname character varying
);


ALTER TABLE public.sseffectiveclass OWNER TO postgres;

--
-- Name: sstrial; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sstrial (
    sstrialtime timestamp without time zone,
    sstrialid integer NOT NULL,
    trialid integer,
    sstriallocationid integer,
    stimulusid integer,
    stimulusclass integer,
    iscorrectiontrial boolean,
    responseselectionid integer,
    responseaccuracyid integer,
    isreinforced boolean,
    subjectid integer,
    protocolmodeid integer
);


ALTER TABLE public.sstrial OWNER TO postgres;

--
-- Name: sstrialcalc; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sstrialcalc (
    sstrialcalcid integer NOT NULL,
    sstrialid integer,
    sseffectiveclassid integer
);


ALTER TABLE public.sstrialcalc OWNER TO postgres;

--
-- Name: sst; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW sst AS
    SELECT DISTINCT sstrial.sstrialid, sstrial.trialid, sstrial.sstrialtime, sstrial.stimulusid, sstrialcalc.sseffectiveclassid, sort.sortquality, spiketrain.spiketrainid, cell.cellid FROM ((((sstrial JOIN spiketrain ON ((spiketrain.trialid = sstrial.trialid))) JOIN sstrialcalc ON ((sstrialcalc.sstrialid = sstrial.sstrialid))) JOIN cell ON ((cell.cellid = spiketrain.cellid))) JOIN sort ON ((sort.sortid = spiketrain.sortid))) ORDER BY sstrial.sstrialtime;


ALTER TABLE public.sst OWNER TO postgres;

--
-- Name: sstriallocation; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sstriallocation (
    sstriallocationid integer NOT NULL,
    sstriallocationname character varying
);


ALTER TABLE public.sstriallocation OWNER TO postgres;

--
-- Name: stimcalc; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE stimcalc (
    stimcalcid integer NOT NULL,
    stimulusid integer,
    subjectid integer
);


ALTER TABLE public.stimcalc OWNER TO postgres;

--
-- Name: stimulus; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE stimulus (
    stimulusid integer NOT NULL,
    stimulusfilename character varying(50),
    motifboundaries double precision[],
    duration double precision
);


ALTER TABLE public.stimulus OWNER TO postgres;

--
-- Name: stimulusselection; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE stimulusselection (
    stimulusselectionid integer NOT NULL,
    stimulusselectionname character varying(200)
);


ALTER TABLE public.stimulusselection OWNER TO postgres;

--
-- Name: surgerytimes; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE surgerytimes (
    surgerytimesid integer NOT NULL,
    subjectid integer,
    surgerytime timestamp without time zone
);


ALTER TABLE public.surgerytimes OWNER TO postgres;

--
-- Name: trialcalc; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE trialcalc (
    trialcalcid integer NOT NULL,
    trialid integer,
    engmodeid integer,
    nontrainingstim integer,
    numpecks integer
);


ALTER TABLE public.trialcalc OWNER TO postgres;

--
-- Name: trialevent; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE trialevent (
    trialeventid integer NOT NULL,
    trialid integer,
    eventtime double precision,
    trialeventtypeid integer,
    eventcode1 integer,
    eventcode2 integer,
    eventcode3 integer,
    eventcode4 integer
);


ALTER TABLE public.trialevent OWNER TO postgres;

--
-- Name: trialeventmeta; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW trialeventmeta AS
    SELECT DISTINCT trial.trialtime, trial.trialid, spiketrain.spiketrainid, trialevent.eventtime, trialevent.trialeventid, trialevent.trialeventtypeid, trialevent.eventcode1, trialevent.eventcode2, trialevent.eventcode3, trialevent.eventcode4, spiketrain.cellid, trial.epochid, trial.stimulusid FROM ((trialevent JOIN trial ON ((trialevent.trialid = trial.trialid))) JOIN spiketrain ON ((spiketrain.trialid = trialevent.trialid))) ORDER BY trial.trialtime, spiketrain.spiketrainid, trialevent.eventtime, trialevent.trialeventid, trialevent.trialeventtypeid, trialevent.eventcode1, trialevent.eventcode2, trialevent.eventcode3, trialevent.eventcode4, spiketrain.cellid, trial.epochid, trial.stimulusid, trial.trialid;


ALTER TABLE public.trialeventmeta OWNER TO postgres;

--
-- Name: trialeventtype; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE trialeventtype (
    trialeventtypeid integer NOT NULL,
    trialeventtypename character varying(200)
);


ALTER TABLE public.trialeventtype OWNER TO postgres;

--
-- Name: behavioralconsequence_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY behavioralconsequence
    ADD CONSTRAINT behavioralconsequence_pkey PRIMARY KEY (behavioralconsequenceid);


--
-- Name: cell_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cell
    ADD CONSTRAINT cell_pkey1 PRIMARY KEY (cellid);


--
-- Name: cellcalc_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cellcalc
    ADD CONSTRAINT cellcalc_pkey1 PRIMARY KEY (cellcalcid);


--
-- Name: electrode_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY electrode
    ADD CONSTRAINT electrode_pkey PRIMARY KEY (electrodeid);


--
-- Name: electrode_serialnumber_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY electrode
    ADD CONSTRAINT electrode_serialnumber_key UNIQUE (serialnumber);


--
-- Name: electrodepad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY electrodepad
    ADD CONSTRAINT electrodepad_pkey PRIMARY KEY (electrodepadid);


--
-- Name: electrodetype_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY electrodetype
    ADD CONSTRAINT electrodetype_pkey1 PRIMARY KEY (electrodetypeid);


--
-- Name: engmode_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY engmode
    ADD CONSTRAINT engmode_pkey1 PRIMARY KEY (engmodeid);


--
-- Name: epoch2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY epoch
    ADD CONSTRAINT epoch2_pkey PRIMARY KEY (epochid);


--
-- Name: experiment_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY experiment
    ADD CONSTRAINT experiment_pkey1 PRIMARY KEY (experimentid);


--
-- Name: experimenter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY experimenter
    ADD CONSTRAINT experimenter_pkey PRIMARY KEY (experimenterid);


--
-- Name: isolationtype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY isolationtype
    ADD CONSTRAINT isolationtype_pkey PRIMARY KEY (isolationtypeid);


--
-- Name: leftright_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY hemisphere
    ADD CONSTRAINT leftright_pkey PRIMARY KEY (hemisphereid);


--
-- Name: penetration_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY penetration
    ADD CONSTRAINT penetration_pkey1 PRIMARY KEY (penetrationid);


--
-- Name: pepcalc_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pepcalc
    ADD CONSTRAINT pepcalc_pkey1 PRIMARY KEY (pepcalcid);


--
-- Name: protocol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY protocol
    ADD CONSTRAINT protocol_pkey PRIMARY KEY (protocolid);


--
-- Name: protocolmode_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY protocolmode
    ADD CONSTRAINT protocolmode_pkey PRIMARY KEY (protocolmodeid);


--
-- Name: protocoltype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY protocoltype
    ADD CONSTRAINT protocoltype_pkey PRIMARY KEY (protocoltypeid);


--
-- Name: region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY region
    ADD CONSTRAINT region_pkey PRIMARY KEY (regionid);


--
-- Name: responseaccuracy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY responseaccuracy
    ADD CONSTRAINT responseaccuracy_pkey PRIMARY KEY (responseaccuracyid);


--
-- Name: responseselection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY responseselection
    ADD CONSTRAINT responseselection_pkey PRIMARY KEY (responseselectionid);


--
-- Name: setcalcid_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY setcalc
    ADD CONSTRAINT setcalcid_pkey1 PRIMARY KEY (setcalcid);


--
-- Name: setcalcstims_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY setcalcstims
    ADD CONSTRAINT setcalcstims_pkey PRIMARY KEY (setcalcid, stimulusid);


--
-- Name: setclassid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY setclass
    ADD CONSTRAINT setclassid_pkey PRIMARY KEY (setclassid);


--
-- Name: sex_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sex
    ADD CONSTRAINT sex_pkey PRIMARY KEY (sexid);


--
-- Name: site_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_pkey PRIMARY KEY (siteid);


--
-- Name: sort_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sort
    ADD CONSTRAINT sort_pkey PRIMARY KEY (sortid);


--
-- Name: spiketrain_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY spiketrain
    ADD CONSTRAINT spiketrain_pkey PRIMARY KEY (spiketrainid);


--
-- Name: sseffectiveclass_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sseffectiveclass
    ADD CONSTRAINT sseffectiveclass_pkey PRIMARY KEY (sseffectiveclassid);


--
-- Name: sstrial_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sstrial
    ADD CONSTRAINT sstrial_pkey PRIMARY KEY (sstrialid);


--
-- Name: sstrialcalc_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sstrialcalc
    ADD CONSTRAINT sstrialcalc_pkey1 PRIMARY KEY (sstrialcalcid);


--
-- Name: sstriallocation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sstriallocation
    ADD CONSTRAINT sstriallocation_pkey PRIMARY KEY (sstriallocationid);


--
-- Name: stimcalc_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stimcalc
    ADD CONSTRAINT stimcalc_pkey1 PRIMARY KEY (stimcalcid);


--
-- Name: stimulus_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stimulus
    ADD CONSTRAINT stimulus_pkey1 PRIMARY KEY (stimulusid);


--
-- Name: stimulus_stimulusfilename_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stimulus
    ADD CONSTRAINT stimulus_stimulusfilename_key UNIQUE (stimulusfilename);


--
-- Name: stimulusselection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stimulusselection
    ADD CONSTRAINT stimulusselection_pkey PRIMARY KEY (stimulusselectionid);


--
-- Name: subject_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY subject
    ADD CONSTRAINT subject_pkey PRIMARY KEY (subjectid);


--
-- Name: surgerytimesid_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY surgerytimes
    ADD CONSTRAINT surgerytimesid_pkey1 PRIMARY KEY (surgerytimesid);


--
-- Name: trainingtype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY trainingtype
    ADD CONSTRAINT trainingtype_pkey PRIMARY KEY (trainingtypeid);


--
-- Name: trial_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY trial
    ADD CONSTRAINT trial_pkey PRIMARY KEY (trialid);


--
-- Name: trialcalc_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY trialcalc
    ADD CONSTRAINT trialcalc_pkey1 PRIMARY KEY (trialcalcid);


--
-- Name: trialevent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY trialevent
    ADD CONSTRAINT trialevent_pkey PRIMARY KEY (trialeventid);


--
-- Name: trialeventtype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY trialeventtype
    ADD CONSTRAINT trialeventtype_pkey PRIMARY KEY (trialeventtypeid);


--
-- Name: cell_cellid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX cell_cellid_idx ON cell USING btree (cellid);


--
-- Name: cell_siteid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX cell_siteid_idx ON cell USING btree (siteid);


--
-- Name: cell_sortmarkercode_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX cell_sortmarkercode_idx ON cell USING btree (sortmarkercode);


--
-- Name: cellcalc_cellcalcid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX cellcalc_cellcalcid_idx ON cellcalc USING btree (cellcalcid);


--
-- Name: cellcalc_cellid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX cellcalc_cellid_idx ON cellcalc USING btree (cellid);


--
-- Name: cellcalc_engmodeid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX cellcalc_engmodeid_idx ON cellcalc USING btree (engmodeid);


--
-- Name: epoch_endtimestamp_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX epoch_endtimestamp_idx ON epoch USING btree (endtimestamp);


--
-- Name: epoch_epochid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX epoch_epochid_idx ON epoch USING btree (epochid);


--
-- Name: epoch_protocolid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX epoch_protocolid_idx ON epoch USING btree (protocolid);


--
-- Name: epoch_starttimestamp_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX epoch_starttimestamp_idx ON epoch USING btree (starttimestamp);


--
-- Name: epoch_subjectid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX epoch_subjectid_idx ON epoch USING btree (subjectid);


--
-- Name: protocol_protocolid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX protocol_protocolid_idx ON protocol USING btree (protocolid);


--
-- Name: protocol_protocolmodeid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX protocol_protocolmodeid_idx ON protocol USING btree (protocolmodeid);


--
-- Name: protocol_protocoltypeid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX protocol_protocoltypeid_idx ON protocol USING btree (protocoltypeid);


--
-- Name: protocol_stimulusselectionid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX protocol_stimulusselectionid_idx ON protocol USING btree (stimulusselectionid);


--
-- Name: protocolmode_protocolmodeid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX protocolmode_protocolmodeid_idx ON protocolmode USING btree (protocolmodeid);


--
-- Name: protocolmode_protocolmodename_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX protocolmode_protocolmodename_idx ON protocolmode USING btree (protocolmodename);


--
-- Name: protocoltype_protocoltypeid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX protocoltype_protocoltypeid_idx ON protocoltype USING btree (protocoltypeid);


--
-- Name: protocoltype_protocoltypename_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX protocoltype_protocoltypename_idx ON protocoltype USING btree (protocoltypename);


--
-- Name: spiketrain_cellid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spiketrain_cellid_idx ON spiketrain USING btree (cellid);


--
-- Name: spiketrain_sortid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spiketrain_sortid_idx ON spiketrain USING btree (sortid);


--
-- Name: spiketrain_spiketrainid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spiketrain_spiketrainid_idx ON spiketrain USING btree (spiketrainid);


--
-- Name: spiketrain_trialid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX spiketrain_trialid_idx ON spiketrain USING btree (trialid);


--
-- Name: sstrial_responseaccuracyid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX sstrial_responseaccuracyid_idx ON sstrial USING btree (responseaccuracyid);


--
-- Name: sstrial_responseselectionid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX sstrial_responseselectionid_idx ON sstrial USING btree (responseselectionid);


--
-- Name: sstrial_sstrialid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX sstrial_sstrialid_idx ON sstrial USING btree (sstrialid);


--
-- Name: sstrial_sstriallocationid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX sstrial_sstriallocationid_idx ON sstrial USING btree (sstriallocationid);


--
-- Name: sstrial_stimulusid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX sstrial_stimulusid_idx ON sstrial USING btree (stimulusid);


--
-- Name: sstrial_trialid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX sstrial_trialid_idx ON sstrial USING btree (trialid);


--
-- Name: sstrial_trialtime_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX sstrial_trialtime_idx ON sstrial USING btree (sstrialtime);


--
-- Name: sstrialcalc_sstrialid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX sstrialcalc_sstrialid_idx ON sstrialcalc USING btree (sstrialid);


--
-- Name: stimcalc_stimcalcid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX stimcalc_stimcalcid_idx ON stimcalc USING btree (stimcalcid);


--
-- Name: stimcalc_stimulusid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX stimcalc_stimulusid_idx ON stimcalc USING btree (stimulusid);


--
-- Name: stimulus_stimulusfilename_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX stimulus_stimulusfilename_idx ON stimulus USING btree (stimulusfilename);


--
-- Name: stimulus_stimulusid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX stimulus_stimulusid_idx ON stimulus USING btree (stimulusid);


--
-- Name: stimulusselection_stimulusselectionid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX stimulusselection_stimulusselectionid_idx ON stimulusselection USING btree (stimulusselectionid);


--
-- Name: stimulusselection_stimulusselectionname_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX stimulusselection_stimulusselectionname_idx ON stimulusselection USING btree (stimulusselectionname);


--
-- Name: trial_epochid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX trial_epochid_idx ON trial USING btree (epochid);


--
-- Name: trial_stimulusid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX trial_stimulusid_idx ON trial USING btree (stimulusid);


--
-- Name: trial_trialid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX trial_trialid_idx ON trial USING btree (trialid);


--
-- Name: trial_trialtime_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX trial_trialtime_idx ON trial USING btree (trialtime);


--
-- Name: trialcalc_engmodeid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX trialcalc_engmodeid_idx ON trialcalc USING btree (engmodeid);


--
-- Name: trialcalc_sseffectiveclassid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX trialcalc_sseffectiveclassid_idx ON sstrialcalc USING btree (sseffectiveclassid);


--
-- Name: trialcalc_sstrialcalcid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX trialcalc_sstrialcalcid_idx ON sstrialcalc USING btree (sstrialcalcid);


--
-- Name: trialcalc_trialcalcid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX trialcalc_trialcalcid_idx ON trialcalc USING btree (trialcalcid);


--
-- Name: trialcalc_trialid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX trialcalc_trialid_idx ON trialcalc USING btree (trialid);


--
-- Name: trialevent_eventcode1_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX trialevent_eventcode1_idx ON trialevent USING btree (eventcode1);


--
-- Name: trialevent_eventcode2_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX trialevent_eventcode2_idx ON trialevent USING btree (eventcode2);


--
-- Name: trialevent_eventcode3_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX trialevent_eventcode3_idx ON trialevent USING btree (eventcode3);


--
-- Name: trialevent_eventcode4_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX trialevent_eventcode4_idx ON trialevent USING btree (eventcode4);


--
-- Name: trialevent_eventtime_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX trialevent_eventtime_idx ON trialevent USING btree (eventtime);


--
-- Name: trialevent_trialeventid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX trialevent_trialeventid_idx ON trialevent USING btree (trialeventid);


--
-- Name: trialevent_trialeventtypeid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX trialevent_trialeventtypeid_idx ON trialevent USING btree (trialeventtypeid);


--
-- Name: trialevent_trialid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX trialevent_trialid_idx ON trialevent USING btree (trialid);


--
-- Name: trialeventtype_trialeventtypeid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX trialeventtype_trialeventtypeid_idx ON trialeventtype USING btree (trialeventtypeid);


--
-- Name: trialeventtype_trialeventtypename_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX trialeventtype_trialeventtypename_idx ON trialeventtype USING btree (trialeventtypename);


--
-- Name: cell_regionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cell
    ADD CONSTRAINT cell_regionid_fkey FOREIGN KEY (regionid) REFERENCES region(regionid);


--
-- Name: cell_siteid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cell
    ADD CONSTRAINT cell_siteid_fkey FOREIGN KEY (siteid) REFERENCES site(siteid);


--
-- Name: cellcalc_cellid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cellcalc
    ADD CONSTRAINT cellcalc_cellid_fkey FOREIGN KEY (cellid) REFERENCES cell(cellid);


--
-- Name: cellcalc_engmodeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cellcalc
    ADD CONSTRAINT cellcalc_engmodeid_fkey FOREIGN KEY (engmodeid) REFERENCES engmode(engmodeid);


--
-- Name: electrode_electrodetypeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY electrode
    ADD CONSTRAINT electrode_electrodetypeid_fkey FOREIGN KEY (electrodetypeid) REFERENCES electrodetype(electrodetypeid);


--
-- Name: electrodepad_electrodetypeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY electrodepad
    ADD CONSTRAINT electrodepad_electrodetypeid_fkey FOREIGN KEY (electrodetypeid) REFERENCES electrodetype(electrodetypeid);


--
-- Name: epoch_protocolid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY epoch
    ADD CONSTRAINT epoch_protocolid_fkey FOREIGN KEY (protocolid) REFERENCES protocol(protocolid);


--
-- Name: epoch_subjectid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY epoch
    ADD CONSTRAINT epoch_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES subject(subjectid);


--
-- Name: experiment_experimenterid_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY experiment
    ADD CONSTRAINT experiment_experimenterid_fkey1 FOREIGN KEY (experimenterid) REFERENCES experimenter(experimenterid);


--
-- Name: penetration_electrodeid_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY penetration
    ADD CONSTRAINT penetration_electrodeid_fkey1 FOREIGN KEY (electrodeid) REFERENCES electrode(electrodeid);


--
-- Name: penetration_hemisphereid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY penetration
    ADD CONSTRAINT penetration_hemisphereid_fkey FOREIGN KEY (hemisphereid) REFERENCES hemisphere(hemisphereid);


--
-- Name: penetration_subjectid_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY penetration
    ADD CONSTRAINT penetration_subjectid_fkey1 FOREIGN KEY (subjectid) REFERENCES subject(subjectid);


--
-- Name: pepcalc_cellid_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pepcalc
    ADD CONSTRAINT pepcalc_cellid_fkey1 FOREIGN KEY (cellid) REFERENCES cell(cellid);


--
-- Name: pepcalc_engmodeid_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pepcalc
    ADD CONSTRAINT pepcalc_engmodeid_fkey1 FOREIGN KEY (engmodeid) REFERENCES engmode(engmodeid);


--
-- Name: protocol_protocolmodeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY protocol
    ADD CONSTRAINT protocol_protocolmodeid_fkey FOREIGN KEY (protocolmodeid) REFERENCES protocolmode(protocolmodeid);


--
-- Name: protocol_protocoltypeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY protocol
    ADD CONSTRAINT protocol_protocoltypeid_fkey FOREIGN KEY (protocoltypeid) REFERENCES protocoltype(protocoltypeid);


--
-- Name: protocol_stimulusselectionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY protocol
    ADD CONSTRAINT protocol_stimulusselectionid_fkey FOREIGN KEY (stimulusselectionid) REFERENCES stimulusselection(stimulusselectionid);


--
-- Name: setcalc_subjectid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY setcalc
    ADD CONSTRAINT setcalc_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES subject(subjectid);


--
-- Name: setcalcid_setcalcstims_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY setcalcstims
    ADD CONSTRAINT setcalcid_setcalcstims_fkey FOREIGN KEY (setcalcid) REFERENCES setcalc(setcalcid);


--
-- Name: setclassid_setcalcstims_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY setcalcstims
    ADD CONSTRAINT setclassid_setcalcstims_fkey FOREIGN KEY (setclassid) REFERENCES setclass(setclassid);


--
-- Name: site_penetrationid_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_penetrationid_fkey1 FOREIGN KEY (penetrationid) REFERENCES penetration(penetrationid);


--
-- Name: sort_chan1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sort
    ADD CONSTRAINT sort_chan1_fkey FOREIGN KEY (chan1_electrodepadid) REFERENCES electrodepad(electrodepadid);


--
-- Name: sort_chan2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sort
    ADD CONSTRAINT sort_chan2_fkey FOREIGN KEY (chan2_electrodepadid) REFERENCES electrodepad(electrodepadid);


--
-- Name: sort_isolationtypeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sort
    ADD CONSTRAINT sort_isolationtypeid_fkey FOREIGN KEY (isolationtypeid) REFERENCES isolationtype(isolationtypeid);


--
-- Name: sort_primarysourcechan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sort
    ADD CONSTRAINT sort_primarysourcechan_fkey FOREIGN KEY (primarysourcechan) REFERENCES electrodepad(electrodepadid);


--
-- Name: sort_siteid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sort
    ADD CONSTRAINT sort_siteid_fkey FOREIGN KEY (siteid) REFERENCES site(siteid);


--
-- Name: spiketrain_cellid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY spiketrain
    ADD CONSTRAINT spiketrain_cellid_fkey FOREIGN KEY (cellid) REFERENCES cell(cellid);


--
-- Name: spiketrain_sortid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY spiketrain
    ADD CONSTRAINT spiketrain_sortid_fkey FOREIGN KEY (sortid) REFERENCES sort(sortid);


--
-- Name: spiketrain_trialid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY spiketrain
    ADD CONSTRAINT spiketrain_trialid_fkey FOREIGN KEY (trialid) REFERENCES trial(trialid);


--
-- Name: sstrial_protocolmodeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sstrial
    ADD CONSTRAINT sstrial_protocolmodeid_fkey FOREIGN KEY (protocolmodeid) REFERENCES protocolmode(protocolmodeid);


--
-- Name: sstrial_responseaccuracyid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sstrial
    ADD CONSTRAINT sstrial_responseaccuracyid_fkey FOREIGN KEY (responseaccuracyid) REFERENCES responseaccuracy(responseaccuracyid);


--
-- Name: sstrial_responseselectionid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sstrial
    ADD CONSTRAINT sstrial_responseselectionid_fkey FOREIGN KEY (responseselectionid) REFERENCES responseselection(responseselectionid);


--
-- Name: sstrial_sstriallocationid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sstrial
    ADD CONSTRAINT sstrial_sstriallocationid_fkey FOREIGN KEY (sstriallocationid) REFERENCES sstriallocation(sstriallocationid);


--
-- Name: sstrial_stimulusid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sstrial
    ADD CONSTRAINT sstrial_stimulusid_fkey FOREIGN KEY (stimulusid) REFERENCES stimulus(stimulusid);


--
-- Name: sstrial_subjectid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sstrial
    ADD CONSTRAINT sstrial_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES subject(subjectid);


--
-- Name: sstrial_trialid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sstrial
    ADD CONSTRAINT sstrial_trialid_fkey FOREIGN KEY (trialid) REFERENCES trial(trialid);


--
-- Name: sstrialcalc_sstrialid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sstrialcalc
    ADD CONSTRAINT sstrialcalc_sstrialid_fkey FOREIGN KEY (sstrialid) REFERENCES sstrial(sstrialid);


--
-- Name: stimcalc_stimid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stimcalc
    ADD CONSTRAINT stimcalc_stimid_fkey FOREIGN KEY (stimulusid) REFERENCES stimulus(stimulusid);


--
-- Name: stimcalc_subjectid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stimcalc
    ADD CONSTRAINT stimcalc_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES subject(subjectid);


--
-- Name: stimulusid_setcalcstims_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY setcalcstims
    ADD CONSTRAINT stimulusid_setcalcstims_fkey FOREIGN KEY (stimulusid) REFERENCES stimulus(stimulusid);


--
-- Name: subject_experimenterid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY subject
    ADD CONSTRAINT subject_experimenterid_fkey FOREIGN KEY (experimenterid) REFERENCES experimenter(experimenterid);


--
-- Name: subject_sexid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY subject
    ADD CONSTRAINT subject_sexid_fkey FOREIGN KEY (sexid) REFERENCES sex(sexid);


--
-- Name: subject_trainingtypeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY subject
    ADD CONSTRAINT subject_trainingtypeid_fkey FOREIGN KEY (trainingtypeid) REFERENCES trainingtype(trainingtypeid);


--
-- Name: surgerytimes_subjectid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY surgerytimes
    ADD CONSTRAINT surgerytimes_subjectid_fkey FOREIGN KEY (subjectid) REFERENCES subject(subjectid);


--
-- Name: trial_epochid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trial
    ADD CONSTRAINT trial_epochid_fkey FOREIGN KEY (epochid) REFERENCES epoch(epochid);


--
-- Name: trial_stimulusid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trial
    ADD CONSTRAINT trial_stimulusid_fkey FOREIGN KEY (stimulusid) REFERENCES stimulus(stimulusid);


--
-- Name: trialcalc_engmodeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trialcalc
    ADD CONSTRAINT trialcalc_engmodeid_fkey FOREIGN KEY (engmodeid) REFERENCES engmode(engmodeid);


--
-- Name: trialcalc_sseffectiveclassid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sstrialcalc
    ADD CONSTRAINT trialcalc_sseffectiveclassid_fkey FOREIGN KEY (sseffectiveclassid) REFERENCES sseffectiveclass(sseffectiveclassid);


--
-- Name: trialcalc_trialid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trialcalc
    ADD CONSTRAINT trialcalc_trialid_fkey FOREIGN KEY (trialid) REFERENCES trial(trialid);


--
-- Name: trialevent_trialeventtypeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trialevent
    ADD CONSTRAINT trialevent_trialeventtypeid_fkey FOREIGN KEY (trialeventtypeid) REFERENCES trialeventtype(trialeventtypeid);


--
-- Name: trialevent_trialid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trialevent
    ADD CONSTRAINT trialevent_trialid_fkey FOREIGN KEY (trialid) REFERENCES trial(trialid);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: behavioralconsequence; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE behavioralconsequence FROM PUBLIC;
REVOKE ALL ON TABLE behavioralconsequence FROM postgres;
GRANT ALL ON TABLE behavioralconsequence TO postgres;
GRANT SELECT,INSERT ON TABLE behavioralconsequence TO dbuser;


--
-- Name: cell; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE cell FROM PUBLIC;
REVOKE ALL ON TABLE cell FROM postgres;
GRANT ALL ON TABLE cell TO postgres;
GRANT SELECT,INSERT,UPDATE ON TABLE cell TO dbuser;


--
-- Name: cellcalc; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE cellcalc FROM PUBLIC;
REVOKE ALL ON TABLE cellcalc FROM postgres;
GRANT ALL ON TABLE cellcalc TO postgres;
GRANT SELECT,INSERT,UPDATE ON TABLE cellcalc TO dbuser;


--
-- Name: engmode; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE engmode FROM PUBLIC;
REVOKE ALL ON TABLE engmode FROM postgres;
GRANT ALL ON TABLE engmode TO postgres;
GRANT SELECT,INSERT,UPDATE ON TABLE engmode TO dbuser;


--
-- Name: penetration; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE penetration FROM PUBLIC;
REVOKE ALL ON TABLE penetration FROM postgres;
GRANT ALL ON TABLE penetration TO postgres;
GRANT SELECT,INSERT,UPDATE ON TABLE penetration TO dbuser;


--
-- Name: region; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE region FROM PUBLIC;
REVOKE ALL ON TABLE region FROM postgres;
GRANT ALL ON TABLE region TO postgres;
GRANT SELECT,INSERT,UPDATE ON TABLE region TO dbuser;


--
-- Name: site; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE site FROM PUBLIC;
REVOKE ALL ON TABLE site FROM postgres;
GRANT ALL ON TABLE site TO postgres;
GRANT SELECT,INSERT ON TABLE site TO dbuser;


--
-- Name: sort; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE sort FROM PUBLIC;
REVOKE ALL ON TABLE sort FROM postgres;
GRANT ALL ON TABLE sort TO postgres;
GRANT SELECT,INSERT,UPDATE ON TABLE sort TO dbuser;


--
-- Name: subject; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE subject FROM PUBLIC;
REVOKE ALL ON TABLE subject FROM postgres;
GRANT ALL ON TABLE subject TO postgres;
GRANT SELECT,INSERT ON TABLE subject TO dbuser;


--
-- Name: trainingtype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE trainingtype FROM PUBLIC;
REVOKE ALL ON TABLE trainingtype FROM postgres;
GRANT ALL ON TABLE trainingtype TO postgres;
GRANT SELECT,INSERT ON TABLE trainingtype TO dbuser;


--
-- Name: cellmeta; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE cellmeta FROM PUBLIC;
REVOKE ALL ON TABLE cellmeta FROM postgres;
GRANT ALL ON TABLE cellmeta TO postgres;
GRANT SELECT ON TABLE cellmeta TO dbuser;


--
-- Name: cellmetab; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE cellmetab FROM PUBLIC;
REVOKE ALL ON TABLE cellmetab FROM postgres;
GRANT ALL ON TABLE cellmetab TO postgres;
GRANT SELECT ON TABLE cellmetab TO dbuser;


--
-- Name: electrode; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE electrode FROM PUBLIC;
REVOKE ALL ON TABLE electrode FROM postgres;
GRANT ALL ON TABLE electrode TO postgres;
GRANT SELECT,INSERT ON TABLE electrode TO dbuser;


--
-- Name: electrodepad; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE electrodepad FROM PUBLIC;
REVOKE ALL ON TABLE electrodepad FROM postgres;
GRANT ALL ON TABLE electrodepad TO postgres;
GRANT SELECT,INSERT ON TABLE electrodepad TO dbuser;


--
-- Name: epoch; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE epoch FROM PUBLIC;
REVOKE ALL ON TABLE epoch FROM postgres;
GRANT ALL ON TABLE epoch TO postgres;
GRANT SELECT,INSERT,UPDATE ON TABLE epoch TO dbuser;


--
-- Name: experimenter; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE experimenter FROM PUBLIC;
REVOKE ALL ON TABLE experimenter FROM postgres;
GRANT ALL ON TABLE experimenter TO postgres;
GRANT SELECT,INSERT ON TABLE experimenter TO dbuser;


--
-- Name: hemisphere; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE hemisphere FROM PUBLIC;
REVOKE ALL ON TABLE hemisphere FROM postgres;
GRANT ALL ON TABLE hemisphere TO postgres;
GRANT SELECT ON TABLE hemisphere TO dbuser;


--
-- Name: isolationtype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE isolationtype FROM PUBLIC;
REVOKE ALL ON TABLE isolationtype FROM postgres;
GRANT ALL ON TABLE isolationtype TO postgres;
GRANT SELECT,INSERT ON TABLE isolationtype TO dbuser;


--
-- Name: penetrationmeta; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE penetrationmeta FROM PUBLIC;
REVOKE ALL ON TABLE penetrationmeta FROM postgres;
GRANT ALL ON TABLE penetrationmeta TO postgres;
GRANT SELECT,INSERT ON TABLE penetrationmeta TO dbuser;


--
-- Name: pepcalc; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE pepcalc FROM PUBLIC;
REVOKE ALL ON TABLE pepcalc FROM postgres;
GRANT ALL ON TABLE pepcalc TO postgres;
GRANT SELECT,INSERT,UPDATE ON TABLE pepcalc TO dbuser;


--
-- Name: protocol; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE protocol FROM PUBLIC;
REVOKE ALL ON TABLE protocol FROM postgres;
GRANT ALL ON TABLE protocol TO postgres;
GRANT SELECT,INSERT ON TABLE protocol TO dbuser;


--
-- Name: protocolmode; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE protocolmode FROM PUBLIC;
REVOKE ALL ON TABLE protocolmode FROM postgres;
GRANT ALL ON TABLE protocolmode TO postgres;
GRANT SELECT,INSERT ON TABLE protocolmode TO dbuser;


--
-- Name: protocoltype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE protocoltype FROM PUBLIC;
REVOKE ALL ON TABLE protocoltype FROM postgres;
GRANT ALL ON TABLE protocoltype TO postgres;
GRANT SELECT,INSERT ON TABLE protocoltype TO dbuser;


--
-- Name: responseaccuracy; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE responseaccuracy FROM PUBLIC;
REVOKE ALL ON TABLE responseaccuracy FROM postgres;
GRANT ALL ON TABLE responseaccuracy TO postgres;
GRANT SELECT,INSERT ON TABLE responseaccuracy TO dbuser;


--
-- Name: responseselection; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE responseselection FROM PUBLIC;
REVOKE ALL ON TABLE responseselection FROM postgres;
GRANT ALL ON TABLE responseselection TO postgres;
GRANT SELECT,INSERT ON TABLE responseselection TO dbuser;


--
-- Name: setcalc; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE setcalc FROM PUBLIC;
REVOKE ALL ON TABLE setcalc FROM postgres;
GRANT ALL ON TABLE setcalc TO postgres;
GRANT SELECT,INSERT,UPDATE ON TABLE setcalc TO dbuser;


--
-- Name: setcalcstims; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE setcalcstims FROM PUBLIC;
REVOKE ALL ON TABLE setcalcstims FROM postgres;
GRANT ALL ON TABLE setcalcstims TO postgres;
GRANT ALL ON TABLE setcalcstims TO dbuser;


--
-- Name: setclass; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE setclass FROM PUBLIC;
REVOKE ALL ON TABLE setclass FROM postgres;
GRANT ALL ON TABLE setclass TO postgres;
GRANT SELECT ON TABLE setclass TO dbuser;


--
-- Name: sex; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE sex FROM PUBLIC;
REVOKE ALL ON TABLE sex FROM postgres;
GRANT ALL ON TABLE sex TO postgres;
GRANT SELECT,INSERT ON TABLE sex TO dbuser;


--
-- Name: sortmeta; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE sortmeta FROM PUBLIC;
REVOKE ALL ON TABLE sortmeta FROM postgres;
GRANT ALL ON TABLE sortmeta TO postgres;
GRANT SELECT,INSERT ON TABLE sortmeta TO dbuser;


--
-- Name: sortmeta_temp; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE sortmeta_temp FROM PUBLIC;
REVOKE ALL ON TABLE sortmeta_temp FROM postgres;
GRANT ALL ON TABLE sortmeta_temp TO postgres;
GRANT SELECT,INSERT ON TABLE sortmeta_temp TO dbuser;


--
-- Name: spiketrain; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE spiketrain FROM PUBLIC;
REVOKE ALL ON TABLE spiketrain FROM postgres;
GRANT ALL ON TABLE spiketrain TO postgres;
GRANT SELECT,INSERT,UPDATE ON TABLE spiketrain TO dbuser;


--
-- Name: trial; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE trial FROM PUBLIC;
REVOKE ALL ON TABLE trial FROM postgres;
GRANT ALL ON TABLE trial TO postgres;
GRANT SELECT,INSERT,UPDATE ON TABLE trial TO dbuser;


--
-- Name: spiketrainmeta; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE spiketrainmeta FROM PUBLIC;
REVOKE ALL ON TABLE spiketrainmeta FROM postgres;
GRANT ALL ON TABLE spiketrainmeta TO postgres;
GRANT SELECT,INSERT ON TABLE spiketrainmeta TO dbuser;


--
-- Name: sseffectiveclass; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE sseffectiveclass FROM PUBLIC;
REVOKE ALL ON TABLE sseffectiveclass FROM postgres;
GRANT ALL ON TABLE sseffectiveclass TO postgres;
GRANT SELECT,INSERT ON TABLE sseffectiveclass TO dbuser;


--
-- Name: sstrial; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE sstrial FROM PUBLIC;
REVOKE ALL ON TABLE sstrial FROM postgres;
GRANT ALL ON TABLE sstrial TO postgres;
GRANT SELECT,INSERT,UPDATE ON TABLE sstrial TO dbuser;


--
-- Name: sstrialcalc; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE sstrialcalc FROM PUBLIC;
REVOKE ALL ON TABLE sstrialcalc FROM postgres;
GRANT ALL ON TABLE sstrialcalc TO postgres;
GRANT SELECT,INSERT,UPDATE ON TABLE sstrialcalc TO dbuser;


--
-- Name: sst; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE sst FROM PUBLIC;
REVOKE ALL ON TABLE sst FROM postgres;
GRANT ALL ON TABLE sst TO postgres;
GRANT SELECT ON TABLE sst TO dbuser;


--
-- Name: sstriallocation; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE sstriallocation FROM PUBLIC;
REVOKE ALL ON TABLE sstriallocation FROM postgres;
GRANT ALL ON TABLE sstriallocation TO postgres;
GRANT SELECT,INSERT ON TABLE sstriallocation TO dbuser;


--
-- Name: stimcalc; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE stimcalc FROM PUBLIC;
REVOKE ALL ON TABLE stimcalc FROM postgres;
GRANT ALL ON TABLE stimcalc TO postgres;
GRANT SELECT,INSERT,UPDATE ON TABLE stimcalc TO dbuser;


--
-- Name: stimulus; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE stimulus FROM PUBLIC;
REVOKE ALL ON TABLE stimulus FROM postgres;
GRANT ALL ON TABLE stimulus TO postgres;
GRANT SELECT,INSERT,UPDATE ON TABLE stimulus TO dbuser;


--
-- Name: stimulusselection; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE stimulusselection FROM PUBLIC;
REVOKE ALL ON TABLE stimulusselection FROM postgres;
GRANT ALL ON TABLE stimulusselection TO postgres;
GRANT SELECT,INSERT ON TABLE stimulusselection TO dbuser;


--
-- Name: surgerytimes; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE surgerytimes FROM PUBLIC;
REVOKE ALL ON TABLE surgerytimes FROM postgres;
GRANT ALL ON TABLE surgerytimes TO postgres;
GRANT SELECT,INSERT,UPDATE ON TABLE surgerytimes TO dbuser;


--
-- Name: trialcalc; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE trialcalc FROM PUBLIC;
REVOKE ALL ON TABLE trialcalc FROM postgres;
GRANT ALL ON TABLE trialcalc TO postgres;
GRANT SELECT,INSERT,UPDATE ON TABLE trialcalc TO dbuser;


--
-- Name: trialevent; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE trialevent FROM PUBLIC;
REVOKE ALL ON TABLE trialevent FROM postgres;
GRANT ALL ON TABLE trialevent TO postgres;
GRANT SELECT,INSERT ON TABLE trialevent TO dbuser;


--
-- Name: trialeventmeta; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE trialeventmeta FROM PUBLIC;
REVOKE ALL ON TABLE trialeventmeta FROM postgres;
GRANT ALL ON TABLE trialeventmeta TO postgres;
GRANT SELECT,INSERT ON TABLE trialeventmeta TO dbuser;


--
-- Name: trialeventtype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE trialeventtype FROM PUBLIC;
REVOKE ALL ON TABLE trialeventtype FROM postgres;
GRANT ALL ON TABLE trialeventtype TO postgres;
GRANT SELECT,INSERT ON TABLE trialeventtype TO dbuser;


--
-- PostgreSQL database dump complete
--

