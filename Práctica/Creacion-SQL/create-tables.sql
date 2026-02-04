CREATE TABLE Usuario (
    cod NUMBER PRIMARY KEY,
    id NUMBER NOT NULL,
    edad NUMBER NOT NULL,
    orientacion VARCHAR(50) NOT NULL,
    sexo VARCHAR(10) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    provincia VARCHAR(100) NOT NULL,
    pais VARCHAR(100) NOT NULL,
    fecha_inicio_fila DATE NOT NULL,
    fecha_fin_fila DATE NOT NULL,
    actual NUMBER(1, 0) CHECK (actual IN (0, 1)) NOT NULL
);

CREATE TABLE Fecha (
    id_fecha DATE PRIMARY KEY,
    dia_de_la_semana VARCHAR(15) NOT NULL,
    dia_del_mes NUMBER NOT NULL,
    mes_ano VARCHAR(20) NOT NULL,
    ano NUMBER NOT NULL,
    mes VARCHAR(20) NOT NULL
);

CREATE TABLE Hora (
    id_hora NUMBER PRIMARY KEY,
    franja_horaria VARCHAR(50) NOT NULL
);

CREATE TABLE Basura (
    id_basura NUMBER PRIMARY KEY,
    fuente_match VARCHAR(100) NOT NULL,
    tipo_match VARCHAR(100) NOT NULL
);

CREATE TABLE Grupos_Intereses (
    id_grupo NUMBER PRIMARY KEY NOT NULL
);

CREATE TABLE Bridge (
    id_grupo NUMBER NOT NULL,
    id_interes VARCHAR(50) NOT NULL,
    peso FLOAT NOT NULL,
    PRIMARY KEY (id_grupo, id_interes),
    FOREIGN KEY (id_grupo) REFERENCES Grupos_Intereses(id_grupo)
);

CREATE TABLE Matches (
    cod_u1 NUMBER NOT NULL,
    cod_u2 NUMBER NOT NULL,
    id_grupo NUMBER NOT NULL,
    id_fecha DATE NOT NULL,
    id_hora NUMBER NOT NULL,
    id_basura NUMBER NOT NULL,
    id_sesion_1 NUMBER NOT NULL,
    id_sesion_2 NUMBER NOT NULL,
    distancia FLOAT NOT NULL,
    tiempo_entre_likes NUMBER NOT NULL,
    numero_intereses_comun NUMBER NOT NULL,
    PRIMARY KEY (cod_u1, cod_u2),
    FOREIGN KEY (cod_u1) REFERENCES Usuario(cod),
    FOREIGN KEY (cod_u2) REFERENCES Usuario(cod),
    FOREIGN KEY (id_grupo) REFERENCES Grupos_Intereses(id_grupo),
    FOREIGN KEY (id_fecha) REFERENCES Fecha(id_fecha),
    FOREIGN KEY (id_hora) REFERENCES Hora(id_hora),
    FOREIGN KEY (id_basura) REFERENCES Basura(id_basura)
);