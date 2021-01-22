#include <stdio.h>
#define n 9

int main(){
    unsigned int array[n]={0x00000021, 0xffffffff, 0x00000086, 0xffff0000, 0x00000011, 0x0000ffff, 0x00000041, 0x00ffff00, 0x00000047};
    printf("before:\n");
    for(int i=0;i<n;i++){
        printf("%x ", array[i]);
    }
    for(int i=0;i<n-1;i++){
        for(int j=n-2;j>=i;j--){
            if(array[j]>array[j+1]){
                int temp;
                temp=array[j];
                array[j]=array[j+1];
                array[j+1]=temp;
            }
        }
    }
    printf("\n\nafter:\n");
    for(int i=0;i<n;i++){
        printf("%x ", array[i]);
    }
    return 0;
}