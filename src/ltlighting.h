LT_INIT_DECL(ltlighting)

// Enable/disable lighting
struct LTLightingNode : LTWrapNode {
    bool enabled;

    LTLightingNode();
    virtual void draw();
};

struct LTLight : LTWrapNode {
    LTColor ambient;
    LTColor diffuse;
    LTColor specular;
    LTPoint3D position;

    LTLight();
    virtual void draw();
};

struct LTMaterial : LTWrapNode {
    LTfloat shininess;
    LTColor ambient;
    LTColor diffuse;
    LTColor specular;
    LTColor emission;

    LTMaterial();
    virtual void draw();

    void setup();
};
