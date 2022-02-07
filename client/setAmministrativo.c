#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "defines.h"

static void modificaMansione(MYSQL *conn)
{
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[2];

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call ModificaMansione(?, ?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize 'ModificaMansione' statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
    char cf[16];
    char mansione[45];
    printf("Inserisci il codice fiscale del dipendente a cui si vuole modificare la mansione assegnata\n");
    getInput(16, cf, false);
    printf("Inserisci la nuova mansione: ");
    getInput(45, mansione, false);
    param[0].buffer = cf;
    param[1].buffer = mansione;
    param[0].buffer_length = strlen((char *)param[0].buffer);
    param[1].buffer_length = strlen((char *)param[1].buffer);


    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for 'ModificaMansione'\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error(prepared_stmt, "An error occurred while changing employee's job.");
        goto out;
    }

    //non produce un result set
    printf("\nMansione assegnata aggiornata con successo.\nIl dipendente verrà ora segnalato come da trasferire nei report del Settore Spazi.");

    out:
    mysql_stmt_close(prepared_stmt);
}

static void mostraStoricoUffici(MYSQL *conn)
{
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[1];

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call StoricoUffici(?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize 'StoricoUffici' statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
    printf("Inserisci il codice fiscale del dipendente di cui si vuole ottenere lo storico degli uffici\n");
    char string[16];
    getInput(16, string, false);
    param[0].buffer = string;
    param[0].buffer_length = strlen((char *)param[0].buffer);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for 'StroicoUffici't\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error(prepared_stmt, "An error occurred while retrieving the offices report.");
        goto out;
    }



    do {
        dump_result_set(conn, prepared_stmt, "\nUffici occupati nel tempo:\n");
    } while (mysql_stmt_next_result(prepared_stmt) == 0);//mi assicuro di consumare tutto il result set, altrimenti potrei ottenere "out of sync"

    out:
    mysql_stmt_close(prepared_stmt);
}


void runAsAmministrativo(MYSQL *conn)
{
	char options[6] = {'1','2', '3', '4', '5', '6'};
	char op;
	
	printf("Passaggio ad Account del Settore Amministrativo...\n");

	if(!parse_config("users/setAmministrativo.json", &conf)) {
		fprintf(stderr, "Unable to load administrator configuration\n");
		exit(EXIT_FAILURE);
	}

	if(mysql_change_user(conn, conf.db_username, conf.db_password, conf.database)) {
		fprintf(stderr, "mysql_change_user() failed\n");
		exit(EXIT_FAILURE);
	}

	while(true) {
		printf("\033[2J\033[H");
		printf("*** Quale operazione vuoi eseguire? ***\n\n");
		printf("1) Modifica la mansione assegnata a un dipendente\n");
		printf("2) Mostra lo storico degli uffici di un dipendente\n");
		printf("3) Ricerca dipendente per nome\n");
		printf("4) Ricerca dipendente per cognome\n");
        printf("5) Ricerca dipendente per nome e cognome\n");
        printf("6) Esci\n");

		op = multiChoice("Select an option", options, 6);

		switch(op) {
			case '1':
				modificaMansione(conn);
				break;
			case '2':
				mostraStoricoUffici(conn);
				break;
			case '3':
				ricercaDipNome(conn);
				break;
			case '4':
				ricercaDipCognome(conn);
				break;
			case '5':
                ricercaDipNomeCognome(conn);
                break;
            case '6':
                return;
				
			default:
				fprintf(stderr, "Invalid condition at %s:%d\n", __FILE__, __LINE__);
				abort();
		}

		getchar();
	}
}
