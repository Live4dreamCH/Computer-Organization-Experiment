#include <stdio.h>
#define n 9

int main(){
    unsigned int array[n]={0x00000021, 0xffffffff, 0x00000086, 0xffff0000, 0x00000011, 0x0000ffff, 0x00000041, 0x00ffff00, 0x00000047};
    printf("before:\n");
    for(int i=0;i<n;i++){
        printf("%x ", array[i]);
    }

    unsigned int min_value, min_addr;
    for(int i=0;i<n-1;i++){
        min_addr=i;
        min_value=array[i];
        for(int j=i+1;j<n;j++){
            if(array[j]<min_value){
                min_addr=j;
                min_value=array[j];
            }
        }
        if(min_addr!=i){
            array[min_addr]=array[i];
            array[i]=min_value;
        }
    }

    printf("\n\nafter:\n");
    for(int i=0;i<n;i++){
        printf("%x ", array[i]);
    }
    return 0;
}