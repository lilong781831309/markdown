# 一、修改settings.xml
```html
<servers>
	<server>
		<id>nexus</id>
		<username>admin</username>
		<password>admin123</password>
    </server>
</servers>

<mirrors>
    <mirror>
		<id>nexus</id>
		<mirrorOf>*</mirrorOf><!-- 要替代的仓库的id，* 替代所有仓库。 -->
		<name>nexus mirror</name>
		<url>http://lilong.tech/nexus/repository/maven-public/</url>
    </mirror>   
</mirrors>

<profiles>
    <profile>
        <id>jdk18</id>
        <activation>
            <jdk>1.8</jdk>
            <activeByDefault>true</activeByDefault>
        </activation>
        <properties>
            <maven.compiler.source>1.8</maven.compiler.source>
            <maven.compiler.target>1.8</maven.compiler.target>
            <maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>
        </properties>
    </profile>
	<profile>
		<id>nexus</id>
		<!-- 远程仓库列表 -->
		<repositories>
			<repository>
				<id>nexus</id>
				<name>Nexus Repository</name>
				<!-- 虚拟的URL形式,指向镜像的URL-->
				<url>http://nexus</url>
				<layout>default</layout>
				<!-- 表示可以从这个仓库下载releases版本的构件--> 
				<releases>
					<enabled>true</enabled>
				</releases>
				<!-- 表示可以从这个仓库下载snapshot版本的构件 --> 
				<snapshots>
					<enabled>true</enabled>
				</snapshots>
			</repository>
		</repositories>
		<!-- 插件仓库列表 -->
		<pluginRepositories>
			<pluginRepository>
				<id>nexus</id>
				<name>Nexus PluginRepository</name>
				<url>http://nexus</url>
				<layout>default</layout>
				<snapshots>
					<enabled>true</enabled>
				</snapshots>
				<releases>
					<enabled>true</enabled>
				</releases>
			</pluginRepository>
		</pluginRepositories>
	</profile>
</profiles>

<activeProfiles>
	<!-- 本机所有的maven项目都使用1.8编译 -->
	<activeProfile>jdk18</activeProfile>
	<!-- 本机所有的maven项目都使用私服的组件 -->
	<activeProfile>nexus</activeProfile>
</activeProfiles>
```
***
# 二、修改pom.xml
```xml
<properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    <java.version>1.8</java.version>
</properties>

<distributionManagement>
    <repository>
        <!--id的名字可以任意取，但是在setting文件中的属性<server>的ID与这里一致-->
        <id>nexus</id>
        <!--指向仓库类型为host(宿主仓库）的储存类型为Release的仓库-->
        <url>http://lilong.tech/nexus/repository/maven-releases/</url>
    </repository>
    <snapshotRepository>
        <!--指向仓库类型为host(宿主仓库）的储存类型为Snapshot的仓库-->
        <id>nexus</id>
        <url>http://lilong.tech/nexus/repository/maven-snapshots/</url>
    </snapshotRepository>
</distributionManagement>
```