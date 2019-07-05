#include <fstream>
#include <sstream>
#include <iostream>
#include <math.h>
#include <string>
#include <stdlib.h>
#include <cstring>
#include "main.h"
using namespace std;

ifstream setting;
ifstream input;
int currently_clk = 0;
int cache_miss = 0;

int Init_cache(Cache *cache1,int sets,int asso)
{
    for(int x = 0; x <= sets; x++)
    {
        for(int y = 0; y <= asso; y++)
        {
            cache1->data[x][y]  = 0;
            cache1->tag[x][y] = 0;
        }
    }
    return 0;
}

int there_Are_Space_Set(Cache *cache1, int index1, int associativity)
{
    int block_i;
    for (block_i=0; block_i<associativity; block_i++)
    {
        if (cache1->data[index1][block_i]==0)
        {
            return -1;
        }
    }
    return 1;
}

/*int getPosUpper (Cache *cache, int index, int tag, int associativity)
{
    int block_i;
    for (block_i=0; block_i<associativity; block_i++)
    {
        if (cache->tag[index][block_i] == tag){return block_i;}
    }
    return -1;
}

int findLessAccessTSset (Cache *cache1, int index1, int associativity)
{
    int block_i;
    int p_lessAc=0;
    int lessAc = cache1->T_Access[index1][0];
    for (block_i=0; block_i<associativity; block_i++)
    {
        if (cache1->T_Access[index1][block_i] < lessAc)
        {
            lessAc = cache1->T_Access[index1][block_i];
            p_lessAc = block_i;
        }
    }
    return p_lessAc;
}

void write_cache (Cache *cache1, int index[], int tag[], int data1[], int associativity)
{
    int is_full;
    int free_block;
    int p_lAc;
    int position_that_has_this_upper = getPosUpper(cache1, index, tag, associativity);

    // Write Miss
    if (position_that_has_this_upper == -1)
    {
        cache_miss++;
        is_full = there_Are_Space_Set(cache1, index, associativity);
    //Set is full
        if (is_full == 1)
        {
            p_lAc = findLessAccessTSset(cache1, index, associativity);
            cache1->tag[index][p_lAc] = tag; // line1 = upper
            cache1->data[index][p_lAc] = data1;
            cache1->T_Access[index][p_lAc] = currently_clk;  // Update T_Access
        }
    //Set isn't full
        else
        {                  // There are a free block in the set (by index)
            free_block = random_free_space_set (cache1, index, associativity);
            cache1->tag[index][free_block] = tag;
            cache1->data[index][free_block] = data1;
            cache1->T_Access[index][free_block] = currently_clk; // Update the T_Access
        }
    }
    // Write Hit
    else {               // position with the right upper was found
        cache1->tag[index][position_that_has_this_upper] = tag;
        cache1->T_Access[index][position_that_has_this_upper] = currently_clk;
    }
}*/

int main(int argc, char *argv[])
{
    Cache cache;
    int a,b,c,d,i,j,m,k,l = {0};
    char *dat[10000];
    char buf[10000];

    //read first file
    //setting.open("input1.txt",ifstream::in);
    setting.open(argv[1],ifstream::in);
    string type;
    while(setting >> type)
    {
        if     (type == "Address_bits:")  {setting >> a;}
        else if(type == "Number_of_sets:"){setting >> b;}
        else if(type == "Associativity:") {setting >> c;}
        else if(type == "Block_size:")    {setting >> d;}
    }
    setting.close();

    cache.BitsSetting(a,b,c,d);
    cache.FindIndexAndOffset();
    int num_of_indexs = cache.get_index();
    int num_of_offset = cache.get_offset();
    int set_num = b/c;
    int start;
    int index_locate[100000];
    start = num_of_offset+2;
    for(i = 0; i < num_of_indexs; i++)
    {
        index_locate[start++]++;
    }
    ////////////////////////////////////////////////////////////////
    cache.data  = new char*[100000];
    for(i = 0; i < b; i++){cache.data[i] = new char[c];}
    cache.tag   = new int*[100000];
    for(i = 0; i < b; i++){cache.tag[i]  = new int[c];}
    Init_cache(&cache,set_num,c);
    ////////////////////////////////////////////////////////////////

    //read second file
    //char *input = argv[2];
    FILE *ptr_file_input = fopen(argv[2], "rb");
    //input.open(argv[2],ifstream::in);
    //FILE *input = fopen("input2.txt", "r");
    int indexs[10000],tags[10000],temp[10000],temp2[10000];
    int u = 0;
    int v = 0;
    int h = 0;
    int ins_count = 0;
    while (fgets(buf, sizeof(buf), ptr_file_input) != NULL)
    {
            currently_clk += 1;
            cache.data[ins_count] = buf;
            if (buf[0] != '.')
            {
                //dat[h] = buf;
                //cout <<"ins:"<< dat[h] <<endl;
                //cout <<"Address:"<<buf<<endl;
                for(k = 0; index_locate[k] != 1; k++){}
                /********************get index*******************/
                for(l = k + num_of_indexs - 1,i = 0; index_locate[l] != 0; --l,i++)
                {
                    temp[l] = pow(2,i);
                    temp[l] *= (buf[l]-48);
                    indexs[u] += temp[l];
                }
                //cout << "index:"<<indexs[u] <<endl;

                /********************get tag*********************/
                for(m = k-1,j = 0; m >= 0 ; --m,j++)
                {
                    temp2[m] = pow(2,j);
                    temp2[m] *= (buf[m]-48);
                    tags[v] += temp2[m];
                }
                //cout << "tag:"<< tags[v] << endl;

                /*****************Access cache***********************/
                //cache.data[tags[u]][indexs[v]] = dat[h];
                //write_cache(&cache, indexs[u], tags[v], (int)dat[h], c);

                u++;
                v++;
                //cout << "^^^^^LOOP_END^^^^^" << endl;
            }
            cout <<"ins:"<<ins_count<<" ,Address:"<< cache.data[ins_count] <<endl;
            cout <<cache.data[0]<<endl;
            ins_count++;
    }
    //fclose(input);
    fclose(ptr_file_input);


    fstream output;
    //output.open("output.txt",ifstream::out);
    output.open(argv[3],ifstream::out);

    output << "AddressBits: "  << cache.get_bits()   << endl;
    output << "NumbersOfSet: " << cache.get_set()    << endl;
    output << "Associative: "  << cache.get_asso()   << endl;
    output << "BlockSize: "    << cache.get_bsize()  << endl;
    output << "Index bit count: " << num_of_indexs << endl;
    output << "Index bits: ";
    for(j = cache.get_bits()-1; j >= 0; j--)
    {
        if (index_locate[j] == 1)
        {
            output << j << " ";
        }
    }
    output << endl;
    output << "Offset bit count: " << num_of_offset  << endl;
    for(i = 0 ; i < ins_count; i++)
    {
        output << cache.data[i] << endl;
    }
    output << "Total cache miss count: "<< cache_miss <<endl;
    output.close();

    delete []cache.data;
    delete []cache.tag;
    //delete []index_locate;
    return 0;
}

void Cache::BitsSetting(int bits,int sets,int asso,int b_size)
{
    add_bits = bits;
    num_sets = sets;
    associative = asso;
    block_size = b_size;
}

void Cache::FindIndexAndOffset()
{
    index  = log2(num_sets);
    offset = log2(block_size);
}
