CREATE SEQUENCE customerMock_c_id_seq;
CREATE TABLE IF NOT EXISTS public.customerMock
(
    c_id integer NOT NULL DEFAULT nextval('customerMock_c_id_seq'::regclass),
    c_name character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'No Name'::character varying,
    c_type character varying COLLATE pg_catalog."default",
    phone character varying COLLATE pg_catalog."default",
    email character varying COLLATE pg_catalog."default" NOT NULL,
    l_id integer,
    CONSTRAINT customerMock_pkey PRIMARY KEY (c_id),
    CONSTRAINT customerMock_l_id_fkey FOREIGN KEY (l_id)
        REFERENCES public.geo_location (l_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
) PARTITION BY RANGE(c_id);

CREATE TABLE customer_default PARTITION OF customerMock DEFAULT;

CREATE TABLE customer_range_part_1
PARTITION OF customerMock
FOR VALUES FROM (0) TO (300);
 
CREATE TABLE customer_range_part_2
PARTITION OF customerMock
FOR VALUES FROM (300) TO (600);
 
CREATE TABLE customer_range_part_3
PARTITION OF customerMock
FOR VALUES FROM (600) TO (900);

ALTER TABLE IF EXISTS public.customerMock
    OWNER to postgres;
REVOKE ALL ON TABLE public.customerMock FROM trainee;
GRANT ALL ON TABLE public.customerMock TO postgres;
GRANT SELECT ON TABLE public.customerMock TO trainee;

INSERT INTO customerMock
SELECT * FROM customer;


SELECT * FROM customer_default;

SELECT * FROM customer
EXCEPT
SELECT * FROM customerMock;
