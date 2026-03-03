# install-amxmodx-deps

После выполнения этого шага вы получите переменную среды, содержащую аргументы для компилятора с подключением всех установленных инклюдов.

## Параметры

### `deps_list`

Список зависимостей в формате `org/repo[@tag][:path]`, разделённых переносами строк, где:

- `org` - организация/пользователь;
- `repo` - репозиторий;
- `tag` - тег, необязательно, по умолчанию последний релиз;
- `path` - путь от корня репозитория до папки с инклюдами, необязательно, по умолчанию `amxmodx/scripting/include`.

Например:

```yaml
deps_list: |
  AmxxModularEcosystem/ParamsController@1.3.3
  AmxxModularEcosystem/CommandAliases@1.0.1
```

Указывает на:

- [AmxxModularEcosystem/ParamsController](https://github.com/AmxxModularEcosystem/ParamsController) версии [1.3.3](https://github.com/AmxxModularEcosystem/ParamsController/releases/tag/1.3.3);
- [AmxxModularEcosystem/CommandAliases](https://github.com/AmxxModularEcosystem/CommandAliases) версии [1.0.1](https://github.com/AmxxModularEcosystem/CommandAliases/releases/tag/1.0.1).

### `output_var_name`

Название переменной среды, в которую будет записана строка с аргументами для компилятора.

## Использование

```yaml
- uses: AmxxModularEcosystem/install-amxmodx-deps@v1
  with:
    deps_list: |
      AmxxModularEcosystem/ParamsController@1.3.3
      AmxxModularEcosystem/CommandAliases@1.0.1
    output_var_name: DEPS_COMPILER_ARGS
```

Далее, на этапе компиляции:

```yaml
- name: Compile plugin
  env:
    DEPS_COMPILER_ARGS: ${{ env.DEPS_COMPILER_ARGS }}
  run: |
    amxxpc example.sma -o"example.amxx" $DEPS_COMPILER_ARGS
```
