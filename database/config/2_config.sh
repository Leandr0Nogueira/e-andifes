#!/bin/bash
set +e

# DEFINA A VARIÁVEL ABAIXO COMO 0 SE QUISER IGNORAR OS ERROS.
exit_on_error=1;

echo -e "Vamos lá...\n";

declare -a segmentos=(
  "preconfig"
  "types"
  "tables"
  "routines"
  "views"
  "triggers"
  "extra"
  "seed"
);

gcount=0;

for s in "${segmentos[@]}"; do
  lcount=0;

  echo -e "====================> $s\n";
  file="/opt/sql/$s/__create__.txt";

  if [[ ! -f "$file" ]]; then
    echo -e "File $file not found\n";
    exit 1;
  fi

  while read buff; do
    if [[ -z "$buff" || ${buff:0:1} == '#' ]]; then
      continue;
    fi

    obj="/opt/sql/$s/$buff.sql";
    echo -e "🔄  $obj";
    psql -U postgres -d andifes -v ON_ERROR_STOP=on -f $obj;
    exit_status=$?;

    if [[ $exit_status -ne 0 ]]; then
      echo -e "
      ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣆⢀⣶⡶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
      ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⣿⢸⠟⣠⣶⡷⠀⠀⠀⠀⠀⠀⠀⠀⠀
      ⠀⠀⠀⠀⠀⠀⢀⣀⠀⢀⣠⠴⠴⠶⠚⠿⠿⠾⠭⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀
      ⠀⠀⠀⠀⢀⠴⢋⡽⠚⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠢⣀⠀⠀⠀⠀⠀⠀
      ⠀⠀⢀⡔⠁⡰⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⠚⠛⣖⠀⠀⠀⠀
      ⠀⢀⡏⠀⡼⢡⠚⡛⠒⣄⠀⠀⠀⠀⣠⠖⠛⠛⠲⡄⠐⢯⠁⠀⠀⠹⡧⠀⠀⠀
      ⠀⣸⠀⠀⡇⠘⠦⣭⡤⢟⡤⠤⣀⠀⠣⣀⡉⢁⣀⠟⠀⠀⢷⠀⠀⠀⠙⣗⠀⠀
      ⠁⢻⠀⠀⢷⢀⡔⠉⢻⡅⣀⣤⡈⠙⠒⠺⠯⡍⠁⠀⠀⠀⢸⡆⠀⠀⠀⠘⡶⠄
      ⠀⣈⣧⠴⠚⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣰⠃⠀⠀⠀⠀⣸⡇⠀⠀⠀⠀⠸⣔
      ⣾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣧⣤⡤⠴⠖⠋⢹⠃⠀⠀⠀⠀⠀⣷
      ⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⣻⠁⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⣼
      ⠙⠑⣤⣀⠀⠀⠀⠀⠀⢀⠀⠀⢄⣐⠴⠋⠀⠀⠀⠀⠀⠀⠘⢆⠀⠀⠀⠀⣰⠟
      ⠀⠀⠀⣑⡟⠛⠛⠛⠛⠛⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢴⡾⠋⠀
      ⠀⠀⠀⡾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡇⠀⠀
      ⠀⠀⣰⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀
      ⠀⠀⠸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠃⠀⠃ \n
";
      echo -e "❌❌❌❌❌❌❌❌  Ocorreu um erro  ❌❌❌❌❌❌❌❌";
      echo -e "📄  $obj";
      echo -e "ℹ️  Verifique a mensagem de erro acima. Boa sorte!\n\n\n";

      if [[ $exit_on_error -eq 1 ]]; then
        echo -e "ℹ️  Se precisar ignorar os erros temporariamente, verifique o arquivo database/config/2_config.sh\n";
        exit 1;
      fi
    else
      echo -e "✅  OK!\n";
    fi

    lcount=$((lcount+1));
  done < "$file";

  echo -e "$s: $lcount arquivos executados.\n";
  gcount=$((gcount+lcount));
done

echo -e "
     .=gp.
   .\'/\$\$\$\$
   || \"TP\"
   ||          .:                 ____
   ||       .-' |                /\' .\    _____
   ||    .-'    |               /: \___\  / .  /\\
   ||    |      !____           \' / . / /____/..\\
   ||    |   .-'  .-'            \/___/  \'  '\  /
   ||    '.____.-'(                       \'__'\/
   ||     \  /  /__\\
   ||      )(
  |::|    /__\\
  |::|
  |  | =========================================================== |

            ____    ____ _  _ ___  _ ____ ____ ____
            |___ __ |__| |\ | |  \ | |___ |___ [__
            |___    |  | | \| |__/ | |    |___ ___]

\n";
echo -e "🎉  Banco de dados inicializado com sucesso";
echo -e "📊  $gcount arquivos executados no total\n";
