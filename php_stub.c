#include "php_stub.h"
#include "php_embed.h"

char* join(char *parent,char *add){
   char* buffer = (char*) malloc( strlen(parent) + 1 + strlen(add) + 1 );   
   strcpy( buffer, parent );
   strcat( buffer, add );
   return buffer ;
} 
 
#ifdef WIN32
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nShowCmd)
#else
int main(int argc, char **argv)
#endif
{
#ifdef ZTS
	void ***tsrm_ls;
#endif
#ifdef WIN32
	int argc = __argc;
	char **argv = __argv;
#endif

	int retval = SUCCESS;
	#if defined(DARWIN)
	char* code = "include dirname(__DIR__).'/Resources/assets/app.php';";	
	#else
	char* code = "include __DIR__.'/assets/app.php';";
	#endif
	char buf[PATH_MAX]; /* not sure about the "+ 1" */
    char *res = realpath(argv[0], buf);
	#ifdef WIN32
	char *dir = strdup(buf);
	php_dirname(dir, strlen(dir));
	php_embed_module.php_ini_path_override = join(dir,"/embed.ini");
	#else
    char *dir = dirname(buf);
    char *up = dirname(dir);
	#endif
	php_embed_module.php_ini_ignore = 0;
    #ifndef WIN32
    #if defined(DARWIN)
    char *resources = "/Resources";
    char *embed = "/Resources/embed.ini";
    char* getin = join(up,resources);
	#else
    char *resources = "/ext";
    char *embed = "/embed.ini";
    char* getin = join(dir,resources);
    #endif
    
    #if defined(DARWIN)
	php_embed_module.php_ini_path_override = join(up,embed);
	#else
	php_embed_module.php_ini_path_override = join(dir,embed);
	#endif
    #endif
	
	PHP_EMBED_START_BLOCK(argc,argv);
	#ifdef WIN32
	zend_alter_ini_entry("extension_dir", 14, dir, strlen(dir), PHP_INI_ALL, PHP_INI_STAGE_ACTIVATE); 
	#else
	zend_alter_ini_entry("extension_dir", 14, getin, strlen(getin), PHP_INI_ALL, PHP_INI_STAGE_ACTIVATE); 
	#endif
	zend_alter_ini_entry("error_reporting", 16, "0", 1, PHP_INI_ALL, PHP_INI_STAGE_ACTIVATE);
		CG(in_compilation) = 0; /* not initialized but needed for several options */
        retval = zend_eval_string(code, NULL, argv[0] TSRMLS_CC) == SUCCESS ? EXIT_SUCCESS : EXIT_FAILURE;
	PHP_EMBED_END_BLOCK();
	exit(retval);
}
