typedef void FILE;
FILE* fopen(const char* filename, const char* mode);
void fwrite(const void* buffer, unsigned long long size, unsigned long long count, FILE* stream);
