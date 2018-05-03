#include <string.h>
#include "erl_nif.h"
#include "ecrypt-sync.h"

static ERL_NIF_TERM
encrypt(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]) {
    ErlNifBinary input, key, iv, output;
    ECRYPT_ctx *ctx;
    unsigned char* ob;

    if (enif_inspect_binary(env, argv[0], &input) == 0) {
        return enif_make_badarg(env);
    }

    if (enif_inspect_binary(env, argv[1], &key) == 0) {
        return enif_make_badarg(env);
    }

    if (enif_inspect_binary(env, argv[2], &iv) == 0) {
        return enif_make_badarg(env);
    }

    ctx = calloc(1, sizeof(ECRYPT_ctx));
    ob = (unsigned char *)calloc(input.size, sizeof(char));

    ECRYPT_init();
    ECRYPT_keysetup(ctx, key.data, key.size * 8, iv.size * 8);
    ECRYPT_ivsetup(ctx, iv.data);
    ECRYPT_encrypt_bytes(ctx, input.data, ob, input.size);

    free(ctx);

    if (enif_alloc_binary(sizeof(char) * input.size, &output)){
        memcpy(output.data, ob, sizeof(char) * input.size);
    }

    enif_release_binary(&input);
    enif_release_binary(&key);
    enif_release_binary(&iv);

    free(ob);
    return enif_make_binary(env, &output);
}

static ErlNifFunc nif_funcs[] = {
    {"encrypt", 3, encrypt}
};

ERL_NIF_INIT(Elixir.Salsa20, nif_funcs, NULL, NULL, NULL, NULL)
