```xml
<?xml version="1.0" encoding="UTF-8" ?>

<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">

    <!--自定义本地仓库路径-->
    <localRepository>D:\Repository\photon_repository</localRepository>

    <pluginGroups>
    </pluginGroups>

    <proxies>
    </proxies>

    <servers>
    </servers>

    <mirrors>
        <mirror>
			<id>alimaven</id>
			<name>aliyun maven</name>
			<url>http://maven.aliyun.com/nexus/content/groups/public/</url>
			<mirrorOf>central</mirrorOf>     
        </mirror>         
         <mirror>
			<id>centralmaven</id>
			<mirrorOf>central</mirrorOf>
			<name>central maven</name>
			<url>https://mvnrepository.com/</url>
		</mirror>        
        <mirror>
		    <id>nexus-aliyun</id>
		    <name>Nexus aliyun</name>
		    <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
		    <mirrorOf>central</mirrorOf>
		</mirror>       
        <mirror>
		    <id>google</id>
		    <name>google maven</name>
		    <url>https://maven.google.com/</url>
		    <mirrorOf>central</mirrorOf>
		</mirror>
		<mirror>
		    <id>central</id>
		    <name>Maven Repository Switchboard</name>
		    <url>http://repo1.maven.org/maven2/</url>
		    <mirrorOf>central</mirrorOf>
		</mirror>
        <mirror>
            <id>jboss-public-repository-group</id>
            <mirrorOf>central</mirrorOf>
            <name>JBoss Public Repository Group</name>
            <url>http://repository.jboss.org/nexus/content/groups/public</url>
        </mirror>
        <mirror>
			<id>nexus-pentaho</id>
			<mirrorOf>central</mirrorOf>
			<name>Nexus pentaho</name>
			<url>https://nexus.pentaho.org/content/repositories/omni/</url>
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
            <id>jdk11</id>
            <activation>
                <jdk>11</jdk>
                <activeByDefault>false</activeByDefault>
            </activation>
            <properties>
                <maven.compiler.source>11</maven.compiler.source>
                <maven.compiler.target>11</maven.compiler.target>
                <maven.compiler.compilerVersion>11</maven.compiler.compilerVersion>
            </properties>
        </profile>
    </profiles>

    <activeProfiles>
      <activeProfile>jdk18</activeProfile>
      <activeProfile>anotherAlwaysActiveProfile</activeProfile>
    </activeProfiles>
    
</settings>
```

