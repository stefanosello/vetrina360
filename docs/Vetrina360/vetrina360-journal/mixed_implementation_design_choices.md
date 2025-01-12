### Optimistic locking
In general, all model will have [optimistic locking](https://stackoverflow.com/questions/129329/optimistic-vs-pessimistic-locking).  In  Vetrina360, optimistic locking is implemented by using column `lock_version`, integer, default to 0, not null. Because of optimistic locking, every update operation must include the current value for `lock_version` in the model data.

### Soft delete
Maybe not all models, but most of, should implement soft delete. To implement soft delete, I choose to adopt [Discard](https://github.com/jhawthorn/discard) gem. At the time of writing, it seems to be well maintained, well document and really easy to understand and maintain in case of necessity.