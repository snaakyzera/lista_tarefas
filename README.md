# Minhas Tarefas

Lista de tarefas em Flutter usando **sqflite**.

Explicação feita com inteligência artificial.

## Requisitos atendidos

- Tabela `tarefas (id, titulo, concluida)` criada no `onCreate` do banco
- Nova tarefa inserida pelo `TextField` na parte de baixo da tela
- Lista carregada com `FutureBuilder`
- Checkbox marca/desmarca como concluída (UPDATE) e a lixeira exclui com confirmação (DELETE)

## Organização

```
lib/
  main.dart                -> inicia o app e define o tema
  models/tarefa_model.dart -> modelo TarefaModel (toMap / fromMap)
  data/tarefa_dao.dart     -> acesso ao SQLite (criar tabela, salvar, buscar, atualizar, remover)
  pages/home_page.dart     -> tela principal
test/
  widget_test.dart         -> testes do modelo
```

## Como rodar no Android Studio

Precisa ter o Flutter instalado e os plugins **Flutter** e **Dart** no Android Studio.

1. Baixe o projeto: no Android Studio, use **File → New → Project from Version Control** com o link deste repositório, ou baixe pelo botão **Code → Download ZIP** aqui no GitHub e extraia.
2. Abra a pasta do projeto no Android Studio (**File → Open**).
3. No **Terminal** do Android Studio, rode:

   ```bash
   flutter create --project-name lista_tarefas .
   flutter pub get
   ```

   Esse comando gera as pastas de plataforma (como `android/`) na versão do Flutter instalada na máquina. Ele não altera o código do app.
4. Abra um emulador Android no **Device Manager**, selecione ele na barra de cima e clique em **Run ▶**.

## Pelo terminal

```bash
flutter create --project-name lista_tarefas .
flutter pub get
flutter run
```

> O sqflite funciona no **Android** e no **iOS**. Não funciona no Chrome nem no Windows.
