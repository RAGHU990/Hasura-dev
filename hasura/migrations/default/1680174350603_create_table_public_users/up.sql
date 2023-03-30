CREATE TABLE "public"."users" ("id" serial NOT NULL, "username" text NOT NULL, "gender" boolean NOT NULL, "age" integer NOT NULL, PRIMARY KEY ("id") , UNIQUE ("username"));
