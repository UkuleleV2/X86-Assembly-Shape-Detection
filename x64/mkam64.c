#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>

int detect(unsigned char* img);

int main (int argc, char** argv)
{
	char *buffer;

	if(argc != 2 ) 
	{
		printf("The number of arguments is not correct. \n ");
		return 1;
	}
    
	struct stat my_struct;
    	stat(argv[1], &my_struct);				//making struct to get info about size of image
    
	buffer = (char *) malloc(my_struct.st_size);		//allocating memory for our image
	if (buffer == NULL)
	{
        	printf("The name of image is not correct (cannot allocate the memory)\n");
        	return 1;
	}

	int opener = open(argv[1], O_RDONLY, 0);		//opening file
	if (opener == -1) 
	{
		printf("Cannot access file.\n");
		free(buffer);
        	return 1;
    	}
	
	
	int mem = read(opener, buffer, my_struct.st_size);	//reading our image into memory
	int width = *(int *) (buffer + 18);
	int height = *(int *) (buffer + 22);
	short bpp = *(short *) (buffer + 28);
	printf("width = %d, height = %d bpp = %d\n", width , height, bpp );
	if (bpp == 24 && width == 320 && height == 240)
	{
		int output = detect(buffer + 54);
        	if 	(output == 1)
			printf("Shape 1.\n");
	
		else if (output == 2)
			printf("Shape 2.\n");
	
		else if	(output == 0)
			printf("White BMP.\n");
	
		else
			printf("Test scenatrio.\n Value of eax/rax= %d.\n",output);
		
	}
	else
    	printf("This bmp is not 24 bit depth. \n");

	free(buffer);
	close(opener);
	return 0;
}
