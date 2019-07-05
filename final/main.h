#ifndef MAIN_H_INCLUDED
#define MAIN_H_INCLUDED
using namespace std;


class Cache
{
    public:
        void BitsSetting(int bits,int sets,int asso,int b_size);
        void FindIndexAndOffset();

        int get_bits()   {return add_bits;}
        int get_set()    {return num_sets;}
        int get_asso()   {return associative;}
        int get_bsize()  {return block_size;}
        int get_index()  {return index;}
        int get_offset() {return offset;}
        char **data;
        int **tag;
        int **T_Access;

    private:
        int add_bits;
        int num_sets;
        int associative;
        int block_size;
        int index;
        int offset;
};


#endif // MAIN_H_INCLUDED
