{ pkgs, ... }:

{
  environment.sessionVariables = {
    PRISMA_SCHEMA_ENGINE_BINARY = "${prisma-engines}/bin/migration-engine";
    PRISMA_QUERY_ENGINE_BINARY = "${prisma-engines}/bin/query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${prisma-engines}/lib/libquery_engine.node";
    PRISMA_INTROSPECTION_ENGINE_BINARY = "${prisma-engines}/bin/introspection-engine";
    PRISMA_FMT_BINARY = "${prisma-engines}/bin/prisma-fmt";
    PRISMA_ENGINES_CHECKSUM_IGNORE_MISSING = "1";
  };
}
