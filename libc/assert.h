#define assert(expr) _assert(expr, __FILE__, __LINE__, __func__);
void _assert(const char* expr, const char* file, int line, const char* func);
