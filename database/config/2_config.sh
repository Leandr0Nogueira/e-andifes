#!/bin/bash

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
    psql_output=$(psql -U postgres -d andifes -v ON_ERROR_STOP=on -f $obj || true);

    if [[ -z $psql_output ]]; then
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
      exit 1;
    else
      echo -e "✅  OK!\n";
    fi

    lcount=$((lcount+1));
  done < "$file";

  if [[ $s == 'preconfig' ]]; then
    echo -e " $lcount gambiarras feitas.\n";
  else
    echo -e " $lcount objetos criados.\n";
    gcount=$((gcount+lcount));
  fi
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
echo -e "📊  $gcount objetos foram criados no total\n";
