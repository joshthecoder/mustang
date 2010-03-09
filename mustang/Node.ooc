Node: abstract class {
    /**
        Called to compile the token into ooc code used to render at runtime.
    */
    compile: abstract class(m: ContextMetaInfo, c: Composer)
}

ContextMetaInfo: class {}

Composer: class {}
