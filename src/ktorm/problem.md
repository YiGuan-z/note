# 使用ktorm开发过程中遇到的问题

## 在使用ktorm查询数据分页并序列化的时候遇到以下序列化异常

```log
com.fasterxml.jackson.databind.JsonMappingException: org.jetbrains.kotlin.name.ClassId (through reference chain: com.cqsd.vo.Page["data"]->java.util.ArrayList[0]->jdk.proxy2.$Proxy30["entityClass"])
	at com.fasterxml.jackson.databind.JsonMappingException.wrapWithPath(JsonMappingException.java:402)
	at com.fasterxml.jackson.databind.JsonMappingException.wrapWithPath(JsonMappingException.java:361)
	at com.fasterxml.jackson.databind.ser.std.StdSerializer.wrapAndThrow(StdSerializer.java:323)
	at com.fasterxml.jackson.databind.ser.std.BeanSerializerBase.serializeFields(BeanSerializerBase.java:780)
	at com.fasterxml.jackson.databind.ser.BeanSerializer.serialize(BeanSerializer.java:178)
	at com.fasterxml.jackson.databind.ser.impl.IndexedListSerializer.serializeContents(IndexedListSerializer.java:119)
	at com.fasterxml.jackson.databind.ser.impl.IndexedListSerializer.serialize(IndexedListSerializer.java:79)
	at com.fasterxml.jackson.databind.ser.impl.IndexedListSerializer.serialize(IndexedListSerializer.java:18)
	at com.fasterxml.jackson.databind.ser.BeanPropertyWriter.serializeAsField(BeanPropertyWriter.java:732)
	at com.fasterxml.jackson.databind.ser.std.BeanSerializerBase.serializeFields(BeanSerializerBase.java:772)
	at com.fasterxml.jackson.databind.ser.BeanSerializer.serialize(BeanSerializer.java:178)
	at com.fasterxml.jackson.databind.ser.DefaultSerializerProvider._serialize(DefaultSerializerProvider.java:479)
	at com.fasterxml.jackson.databind.ser.DefaultSerializerProvider.serializeValue(DefaultSerializerProvider.java:318)
	at com.fasterxml.jackson.databind.ObjectMapper._writeValueAndClose(ObjectMapper.java:4719)
	at com.fasterxml.jackson.databind.ObjectMapper.writeValue(ObjectMapper.java:3923)
	at io.ktor.serialization.jackson.JacksonConverter$serializeNullable$2.invokeSuspend(JacksonConverter.kt:81)
	at io.ktor.serialization.jackson.JacksonConverter$serializeNullable$2.invoke(JacksonConverter.kt)
	at io.ktor.serialization.jackson.JacksonConverter$serializeNullable$2.invoke(JacksonConverter.kt)
	at io.ktor.http.content.OutputStreamContent$writeTo$2.invokeSuspend(OutputStreamContent.kt:28)
	at io.ktor.http.content.OutputStreamContent$writeTo$2.invoke(OutputStreamContent.kt)
	at io.ktor.http.content.OutputStreamContent$writeTo$2.invoke(OutputStreamContent.kt)
	at io.ktor.http.content.BlockingBridgeKt.withBlocking(BlockingBridge.kt:28)
	at io.ktor.http.content.OutputStreamContent.writeTo(OutputStreamContent.kt:24)
	at io.ktor.server.engine.BaseApplicationResponse$respondWriteChannelContent$2$1.invokeSuspend(BaseApplicationResponse.kt:174)
	at kotlin.coroutines.jvm.internal.BaseContinuationImpl.resumeWith(ContinuationImpl.kt:33)
	at kotlinx.coroutines.DispatchedTask.run(DispatchedTask.kt:106)
	at kotlinx.coroutines.internal.LimitedDispatcher$Worker.run(LimitedDispatcher.kt:115)
	at kotlinx.coroutines.scheduling.TaskImpl.run(Tasks.kt:100)
	at kotlinx.coroutines.scheduling.CoroutineScheduler.runSafely(CoroutineScheduler.kt:584)
	at kotlinx.coroutines.scheduling.CoroutineScheduler$Worker.executeTask(CoroutineScheduler.kt:793)
	at kotlinx.coroutines.scheduling.CoroutineScheduler$Worker.runWorker(CoroutineScheduler.kt:697)
	at kotlinx.coroutines.scheduling.CoroutineScheduler$Worker.run(CoroutineScheduler.kt:684)
	Suppressed: kotlinx.coroutines.JobCancellationException: Job was cancelled
	Suppressed: java.io.IOException: kotlinx.coroutines.JobCancellationException: Job was cancelled; job=CompletableDeferredImpl{Cancelled}@407ce271
		at io.ktor.utils.io.jvm.javaio.OutputAdapter.close(Blocking.kt:134)
		at kotlin.io.CloseableKt.closeFinally(Closeable.kt:59)
		at io.ktor.http.content.OutputStreamContent$writeTo$2.invokeSuspend(OutputStreamContent.kt:27)
		... 13 common frames omitted
	Caused by: kotlinx.coroutines.JobCancellationException: Job was cancelled
Caused by: java.lang.ClassNotFoundException: org.jetbrains.kotlin.name.ClassId
	at java.base/jdk.internal.loader.BuiltinClassLoader.loadClass(BuiltinClassLoader.java:641)
	at java.base/jdk.internal.loader.ClassLoaders$AppClassLoader.loadClass(ClassLoaders.java:188)
	at java.base/java.lang.ClassLoader.loadClass(ClassLoader.java:520)
	at kotlin.reflect.jvm.internal.KDeclarationContainerImpl.parseType(KDeclarationContainerImpl.kt:273)
	at kotlin.reflect.jvm.internal.KDeclarationContainerImpl.loadReturnType(KDeclarationContainerImpl.kt:288)
	at kotlin.reflect.jvm.internal.KDeclarationContainerImpl.findMethodBySignature(KDeclarationContainerImpl.kt:198)
	at kotlin.reflect.jvm.internal.KPropertyImplKt.computeCallerForAccessor(KPropertyImpl.kt:263)
	at kotlin.reflect.jvm.internal.KPropertyImplKt.access$computeCallerForAccessor(KPropertyImpl.kt:1)
	at kotlin.reflect.jvm.internal.KPropertyImpl$Getter$caller$2.invoke(KPropertyImpl.kt:180)
	at kotlin.reflect.jvm.internal.KPropertyImpl$Getter$caller$2.invoke(KPropertyImpl.kt:179)
	at kotlin.SafePublicationLazyImpl.getValue(LazyJVM.kt:107)
	at kotlin.reflect.jvm.internal.KPropertyImpl$Getter.getCaller(KPropertyImpl.kt:179)
	at kotlin.reflect.jvm.ReflectJvmMapping.getJavaMethod(ReflectJvmMapping.kt:63)
	at kotlin.reflect.jvm.ReflectJvmMapping.getJavaGetter(ReflectJvmMapping.kt:48)
	at com.fasterxml.jackson.module.kotlin.KotlinAnnotationIntrospector.getRequiredMarkerFromCorrespondingAccessor(KotlinAnnotationIntrospector.kt:134)
	at com.fasterxml.jackson.module.kotlin.KotlinAnnotationIntrospector.hasRequiredMarker(KotlinAnnotationIntrospector.kt:129)
	at com.fasterxml.jackson.module.kotlin.KotlinAnnotationIntrospector.access$hasRequiredMarker(KotlinAnnotationIntrospector.kt:28)
	at com.fasterxml.jackson.module.kotlin.KotlinAnnotationIntrospector$hasRequiredMarker$hasRequired$1.invoke(KotlinAnnotationIntrospector.kt:45)
	at com.fasterxml.jackson.module.kotlin.KotlinAnnotationIntrospector$hasRequiredMarker$hasRequired$1.invoke(KotlinAnnotationIntrospector.kt:38)
	at com.fasterxml.jackson.module.kotlin.ReflectionCache.javaMemberIsRequired(ReflectionCache.kt:102)
	at com.fasterxml.jackson.module.kotlin.KotlinAnnotationIntrospector.hasRequiredMarker(KotlinAnnotationIntrospector.kt:38)
	at com.fasterxml.jackson.databind.introspect.AnnotationIntrospectorPair.hasRequiredMarker(AnnotationIntrospectorPair.java:326)
	at com.fasterxml.jackson.databind.introspect.AnnotationIntrospectorPair.hasRequiredMarker(AnnotationIntrospectorPair.java:326)
	at com.fasterxml.jackson.databind.introspect.POJOPropertyBuilder.getMetadata(POJOPropertyBuilder.java:230)
	at com.fasterxml.jackson.databind.introspect.POJOPropertiesCollector._anyIndexed(POJOPropertiesCollector.java:1326)
	at com.fasterxml.jackson.databind.introspect.POJOPropertiesCollector._sortProperties(POJOPropertiesCollector.java:1228)
	at com.fasterxml.jackson.databind.introspect.POJOPropertiesCollector.collectAll(POJOPropertiesCollector.java:495)
	at com.fasterxml.jackson.databind.introspect.POJOPropertiesCollector.getJsonValueAccessor(POJOPropertiesCollector.java:286)
	at com.fasterxml.jackson.databind.introspect.BasicBeanDescription.findJsonValueAccessor(BasicBeanDescription.java:258)
	at com.fasterxml.jackson.databind.ser.BasicSerializerFactory.findSerializerByAnnotations(BasicSerializerFactory.java:393)
	at com.fasterxml.jackson.databind.ser.BeanSerializerFactory._createSerializer2(BeanSerializerFactory.java:225)
	at com.fasterxml.jackson.databind.ser.BeanSerializerFactory.createSerializer(BeanSerializerFactory.java:174)
	at com.fasterxml.jackson.databind.SerializerProvider._createUntypedSerializer(SerializerProvider.java:1503)
	at com.fasterxml.jackson.databind.SerializerProvider._createAndCacheUntypedSerializer(SerializerProvider.java:1451)
	at com.fasterxml.jackson.databind.SerializerProvider.findPrimaryPropertySerializer(SerializerProvider.java:717)
	at com.fasterxml.jackson.databind.ser.impl.PropertySerializerMap.findAndAddPrimarySerializer(PropertySerializerMap.java:64)
	at com.fasterxml.jackson.databind.ser.BeanPropertyWriter._findAndAddDynamic(BeanPropertyWriter.java:901)
	at com.fasterxml.jackson.databind.ser.BeanPropertyWriter.serializeAsField(BeanPropertyWriter.java:710)
	at com.fasterxml.jackson.databind.ser.std.BeanSerializerBase.serializeFields(BeanSerializerBase.java:772)
	... 28 common frames omitted
```

刚看到的时候不明所以，直到我使用debug定位到结果对象的时候才发现，需要自行对进行映射来构建结果集，不然的话结果集就是它自己帮你实现的一个对象。

```kotlin
val users = userQuerySource.select().limit(10).map { Users.createEntity(row = it) }
```

>这是一个ktorm中的分页查询方法，我使用它的定义表来对数据结果进行创建，ktorm中对数据模型的定义是接口，使用`data class`会在序列api中无法使用`add`方法，所以我也就保持了使用接口，这就意味着我必须写一个映射方法来对ktorm中查询出来的结果集进行转换（强制使用DTO，VO进行序列化），这一点还行。但是我必须写一个又臭又长的映射方法，例如。

```kotlin
fun projectsWhere(condition: ColumnDeclaring<Boolean>): List<UserDTO> {
        return userQuerySource
                .select()
                .limit(page,size)
                .where(condition)
                .map { row ->
                    UserDTO(
                        id = row[Users.id],
                        name = row[Users.name].orEmpty(),
                        address = row[Users.address].orEmpty(),
                        avatar = row[Users.avatar].orEmpty(),
                        email = row[Users.email].orEmpty(),
                        status = row[Users.status].orEmpty(),
                    )
                }
    }
```

该函数直到`map`之前都非常美妙，到了map就惨不忍睹了，或许可以尝试定义一个扩展函数来对这个方法进行扩展。

### 解决思路

将`QueryRowSet`映射为对象的方法进行拓展，使用ksp插件属于大炮打蚊子，只能通过反射将其设置进去，其实我不太想使用jvm的反射。

让map使用内联函数接收一个真泛型，对真泛型和`QueryRowSet`进行解析并往内部自动配置一个`transform`，得益于kotlin的依赖库极具扩展性，可以直接使用包里给出的

`public inline fun <R, C : MutableCollection<in R>> Query.mapTo(destination: C, transform: (row: QueryRowSet) -> R): C` 函数进行封装。

#### 效果代码

```kotlin
val users:List<UserDTO> = userQuerySource.select().limit(page, size).mapDTO()
```

最终编写出来的方法效果是这样的。

```kotlin
fun <R : Any> Query.map(table: BaseTable<*>, r: KClass<R>): List<R> {
    val name = r.simpleName
    val constructor = r.primaryConstructor
    return if (constructor != null) {
        mapTo(constructor, table)
    } else {
        throw NullPointerException("找不到$name 的主构造函数")
    }
}

fun <R : Any> Query.mapTo(
    constructor: KFunction<R>,
    table: BaseTable<*>
): ArrayList<R> {
    val parameters = constructor.parameters
    //将构造器中存在的列映射为table中的Column
    val columns = parameters.map { param -> runCatching { table[param.name!!] }.getOrNull() }
    val transform: (row: QueryRowSet) -> R = { row ->
        val columnsData = columns.map {
            if (it != null) {
                row[it]
            } else {
                null
            }
        }.toTypedArray()
        constructor.call(*columnsData)
    }
    return mapTo(ArrayList(), transform)
}
```

使用效果

```kotlin
val map: List<UserDTO> = users.select().limit(10).map(Users, UserDTO::class)
```

通过DTO的主构造函数中的参数名来对`QueryRowSet`的数据列进行映射，再在transform方法里面通过获取被映射的列来获取数据并调用构造器方法。

这是暂时的解决思路。
