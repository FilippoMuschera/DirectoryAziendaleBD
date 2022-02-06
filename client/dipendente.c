#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "defines.h"

//TODO UNIFICARE FUNZIONI E METTERE UNO SWITCH + ENUM

void ricercaDipNomeCognome(MYSQL *conn)
{
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[2];

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call RicercaDipNomeCognome(?, ?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize career report statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
    param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
    char nome[45];
    char cognome[45];
    printf("Inserisci il nome del dipendente da cercare: ");
    getInput(45, nome, false);
    printf("Inserisci il cognome del dipendente da cercare: ");
    getInput(45, cognome, false);
    param[0].buffer = nome;
    param[1].buffer = cognome;
    param[0].buffer_length = strlen((char *)param[0].buffer);
    param[1].buffer_length = strlen((char *)param[1].buffer);


    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for career report\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error(prepared_stmt, "An error occurred while retrieving the career report.");
    goto out;
}



do {
    dump_result_set(conn, prepared_stmt, "\nDipendenti trovati:");
} while (mysql_stmt_next_result(prepared_stmt) == 0);

    out:
        mysql_stmt_close(prepared_stmt);
}



void ricercaDipCognome(MYSQL *conn) {
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[1];

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call RicercaDipendenteCognome(?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize career report statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
    printf("Inserisci il cognome del dipendente da cercare: ");
    char string[45];
    getInput(128, string, false);
    param[0].buffer = string;
    param[0].buffer_length = strlen((char *)param[0].buffer);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for career report\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error(prepared_stmt, "An error occurred while retrieving the career report.");
        goto out;
    }



    do {
        dump_result_set(conn, prepared_stmt, "\nDipendenti trovati:");
    } while (mysql_stmt_next_result(prepared_stmt) == 0);

    out:
    mysql_stmt_close(prepared_stmt);
}

void ricercaDipNome(MYSQL *conn) {
	MYSQL_STMT *prepared_stmt;
	MYSQL_BIND param[1];

	// Prepare stored procedure call
	if(!setup_prepared_stmt(&prepared_stmt, "call RicercaDipendenteNome(?)", conn)) {
		finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize career report statement\n", false);
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));

	param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
    printf("Inserisci il nome del dipendente da cercare: ");
    char string[45];
    getInput(128, string, false);
    param[0].buffer = string;
	param[0].buffer_length = strlen((char *)param[0].buffer);

	if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
		finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for career report\n", true);
	}

	// Run procedure
	if (mysql_stmt_execute(prepared_stmt) != 0) {
		print_stmt_error(prepared_stmt, "An error occurred while retrieving the career report.");
		goto out;
	}



    do {
        dump_result_set(conn, prepared_stmt, "\nDipendenti trovati:");
    } while (mysql_stmt_next_result(prepared_stmt) == 0);

    out:
	mysql_stmt_close(prepared_stmt);
}

void ricercaPostazione(MYSQL *conn)
{
    MYSQL_STMT *prepared_stmt;
    MYSQL_BIND param[1];

    // Prepare stored procedure call
    if(!setup_prepared_stmt(&prepared_stmt, "call RicercaPostazione(?)", conn)) {
        finish_with_stmt_error(conn, prepared_stmt, "Unable to initialize career report statement\n", false);
    }

    // Prepare parameters
    memset(param, 0, sizeof(param));

    param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
    printf("Inserisci il numero di telefono ESTERNO della postazione da cercare: ");
    char postazione[45];
    getInput(128, postazione, false);
    param[0].buffer = postazione;
    param[0].buffer_length = strlen((char *)param[0].buffer);

    if (mysql_stmt_bind_param(prepared_stmt, param) != 0) {
        finish_with_stmt_error(conn, prepared_stmt, "Could not bind parameters for career report\n", true);
    }

    // Run procedure
    if (mysql_stmt_execute(prepared_stmt) != 0) {
        print_stmt_error(prepared_stmt, "An error occurred while retrieving the career report.");
        goto out;
    }



    do {
        dump_result_set(conn, prepared_stmt, "\nDipendenti trovati:");
    } while (mysql_stmt_next_result(prepared_stmt) == 0);

    out:
    mysql_stmt_close(prepared_stmt);
}



void runAsDipendente(MYSQL *conn)
{
	char options[5] = {'1','2', '3', '4', '5'};
	char op;
	
	printf("Passaggio a account di tipo dipendente...\n");

	if(!parse_config("users/dipendente.json", &conf)) {
		fprintf(stderr, "Unable to load 'dipendente' configuration\n");
		exit(EXIT_FAILURE);
	}

	if(mysql_change_user(conn, conf.db_username, conf.db_password, conf.database)) {
		fprintf(stderr, "mysql_change_user() failed\n");
		exit(EXIT_FAILURE);
	}

	while(true) {
		printf("\033[2J\033[H");
		printf("*** Quale Operazione vuoi eseguire? ***\n\n");
		printf("1) Ricerca dipendente per nome\n");
        printf("2) Ricerca dipendente per cognome\n");
        printf("3) Ricerca dipendente per nome e cognome\n");
        printf("4) Ricerca postazione\n");
        printf("5) Esci\n");

		op = multiChoice("Selezione un'opzione", options, 5);

		switch(op) {
			case '1':
                ricercaDipNome(conn);
				break;
				
			case '2':
				ricercaDipCognome(conn);
                break;
            case '3':
                ricercaDipNomeCognome(conn);
                break;
            case '4':
                ricercaPostazione(conn);
                break;
            case '5':
                return;
			default:
				fprintf(stderr, "Invalid condition at %s:%d\n", __FILE__, __LINE__);
				abort();
		}

		getchar();
	}
}
