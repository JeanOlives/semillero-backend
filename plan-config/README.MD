# Instrucciones

Para registrar un nuevo juegos de jars de un aplication group, por favor crear un nuevo plan con la siguiente sintaxis.

```xml
<plan id="plan_[groupo_id]" reloadable="true">
    <plugin name="front.[grupo_id].customevents.impl-1.0.0.jar" path="../../SEM/plugins/front.[grupo_id].customevents.impl-1.0.0.jar" />
    .
    .
    .
</plan>
```

Añadir sus plugins en el plan, no añadir el commons...jar, este ya esta añadido en otro plan.