#include <stdlib/primitives/field/field.hpp>
#include <stdlib/primitives/witness/witness.hpp>
#include <stdlib/hash/blake2s/blake2s.hpp>

template <typename Composer>
class GenCircuit
{
public:
    typedef plonk::stdlib::field_t<Composer> field_ct;
    typedef plonk::stdlib::public_witness_t<Composer> public_witness_ct;
    typedef plonk::stdlib::byte_array<Composer> byte_array_ct;

    static constexpr size_t NUM_PUBLIC_INPUTS = 4;

    static Composer generate()
    {
        // todo use proper srs?
        Composer composer("../../barretenberg/cpp/srs_db/ignition");

        byte_array_ct input_buffer(&composer);
        for (size_t i = 0; i < NUM_PUBLIC_INPUTS; ++i)
        {
            input_buffer.write(byte_array_ct(field_ct(public_witness_ct(&composer, i))));
        }

        plonk::stdlib::blake2s<Composer>(input_buffer);

        return composer;
    }
};