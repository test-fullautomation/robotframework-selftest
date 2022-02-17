#include <stdio.h>
#include <string.h>

#include <dlt.h>

static bool appWait = true;
char *WELCOMEMSG = "Welcome to Robotframework AIO DLTSelfTestApp...";
char *PINGMSG = "Ping message from Robotframework AIO DLTSelfTestApp";

DLT_DECLARE_CONTEXT(con_rbfw);

int rbfw_dlt_injection_callback(uint32_t service_id, void *data, uint32_t length);

int main()
{
    char *appID = "RBFW";
    char *ctxID = "TEST";
    int wait_s = 5;

    // register DLT app and context
    DLT_REGISTER_APP(appID, "DLTSelfTestApp from Robotframework AIO");

    DLT_REGISTER_CONTEXT(con_rbfw, ctxID, "DLTSelfTestApp context");

    // send Welcome DLT LOG
    DLT_LOG(con_rbfw, DLT_LOG_INFO, DLT_STRING(WELCOMEMSG));

    // register DLT injection
    DLT_REGISTER_INJECTION_CALLBACK(con_rbfw, 0x1000, rbfw_dlt_injection_callback);

    // wait for injection command until get "exit" command 
    while(appWait)
    {
        // send ping message every wait_s second(s)
        sleep(wait_s);
        DLT_LOG(con_rbfw, DLT_LOG_INFO, DLT_STRING(PINGMSG));
    };

    // unregister DLT context and app
    DLT_UNREGISTER_CONTEXT(con_rbfw);

    DLT_UNREGISTER_APP();

    return 0;
}

int rbfw_dlt_injection_callback(uint32_t service_id, void *data, uint32_t length)
{
    char text[1024];
    
    DLT_LOG(con_rbfw, DLT_LOG_INFO, DLT_STRING("Injection: "), DLT_UINT32(service_id));
    printf("Injection %d, Length=%d \n", service_id, length);

    if (length > 0) {
        dlt_print_mixed_string(text, 1024, data, length, 0);
        printf("%s \n", data);
        // DLT_LOG(con_rbfw, DLT_LOG_INFO, DLT_STRING("Data: "), DLT_STRING(text));
        // printf("%s \n", text);

        if(strcmp(data, "exit") == 0){
            DLT_LOG(con_rbfw, DLT_LOG_INFO, DLT_STRING("Bye..."));
            appWait = false;
        } else if(strcmp(data, "welcome") == 0){
            DLT_LOG(con_rbfw, DLT_LOG_INFO, DLT_STRING(WELCOMEMSG));
        } else {
            DLT_LOG(con_rbfw, DLT_LOG_INFO, DLT_STRING("Data: "), DLT_STRING(text));
        }
    }

    return 0;
}